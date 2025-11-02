// lib/core/service/api_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io' show SocketException;

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/core/helper/shared_preference_helper.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/method.dart';

/// ---------- kleine Helfer ----------
extension _SafeString on String {
  String safeSubstring(int start, [int? end]) {
    final len = length;
    if (len == 0) return '';
    final s = start.clamp(0, len);
    final e = (end ?? len).clamp(s, len);
    return substring(s, e);
  }
}

String _redactAuth(String? auth, {int keep = 12}) {
  if (auth == null || auth.isEmpty) return '';
  final cut = auth.length < keep ? auth.length : keep;
  return auth.safeSubstring(0, cut) + '…';
}

bool _isTokenKey(String key) {
  final k = key.toLowerCase();
  return k == 'token' ||
      k == 'api_token' ||
      k == 'apitoken' ||
      k == 'auth_token' ||
      k == 'x-auth-token';
}

/// ---------- ApiClient ----------
class ApiClient extends GetxService {
  final SharedPreferences sharedPreferences;
  ApiClient({required this.sharedPreferences});

  String _token = '';

  void initToken() {
    _token =
        sharedPreferences.getString(SharedPreferenceHelper.accessTokenKey) ?? '';
  }

  /// Speichert Token; bei [ensureBearerPrefix] wird „Bearer “ ergänzt.
  Future<void> saveToken(String raw, {bool ensureBearerPrefix = true}) async {
    final value =
    ensureBearerPrefix ? (raw.startsWith('Bearer ') ? raw : 'Bearer $raw') : raw;
    await sharedPreferences.setString(
      SharedPreferenceHelper.accessTokenKey,
      value,
    );
    _token = value;
    if (kDebugMode) {
      debugPrint('Saved auth token (first 12): ${bareToken.safeSubstring(0, 12)}');
      debugPrint('Has Bearer prefix: ${value.startsWith('Bearer ')}');
    }
  }

  String get _authHeaderValue {
    if (_token.isEmpty) return '';
    return _token.startsWith('Bearer ') ? _token : 'Bearer $_token';
  }

  /// Wert, wie er im Authorization-Header benutzt wird (inkl. „Bearer “).
  String get authorizationHeaderValue {
    initToken();
    return _authHeaderValue;
  }

  /// Nackter Token OHNE „Bearer “
  String get bareToken {
    initToken();
    final v = _token;
    return v.startsWith('Bearer ') ? v.substring(7) : v;
  }

  Map<String, String> _baseHeaders({
    required bool withAuth,
    required bool sendJson,
  }) {
    final h = <String, String>{
      'Accept': 'application/json',
      'Accept-Language': Get.locale?.toLanguageTag() ?? 'en-US',
    };
    if (sendJson) h['Content-Type'] = 'application/json; charset=utf-8';
    if (withAuth) {
      initToken();
      if (_token.isNotEmpty) {
        h['Authorization'] = _authHeaderValue;
      }
    }
    return h;
  }

  /// Entfernt Token-Query-Parameter aus bestehender URL.
  Uri _sanitizeUriQuery(Uri url) {
    if (url.queryParameters.isEmpty) return url;
    final qp = Map<String, String>.from(url.queryParameters);
    qp.removeWhere((k, _) => _isTokenKey(k));
    return url.replace(queryParameters: qp);
  }

  Uri _buildUri(
      String uri,
      String method,
      Map<String, dynamic>? params, {
        required bool forceQueryToken,
        String queryTokenKey = 'token',
      }) {
    var url = Uri.parse(uri);
    url = _sanitizeUriQuery(url);

    // Zusätzliche GET-Parameter (niemals Token-Felder aus params)
    if (method == Method.getMethod && params != null && params.isNotEmpty) {
      final qp = <String, String>{};
      params.forEach((k, v) {
        final key = k.toString();
        if (_isTokenKey(key)) return;
        qp[key] = v?.toString() ?? '';
      });
      if (qp.isNotEmpty) {
        url = url.replace(queryParameters: {...url.queryParameters, ...qp});
      }
    }

    // Fallback: Token als Query anhängen (URL-encoded)
    if (forceQueryToken && bareToken.isNotEmpty) {
      final qp = Map<String, String>.from(url.queryParameters);
      qp[queryTokenKey] = bareToken; // Uri.replace encodiert
      url = url.replace(queryParameters: qp);
    }

    return url;
  }

  /// Entscheidet, ob wir mit Query-Token neu versuchen sollen.
  bool _shouldFallbackWithQuery(String body) {
    final b = body.toLowerCase();
    return b.contains('token is not defined') ||
        b.contains('unexpected control character');
  }

  Future<ResponseModel> request(
      String uri,
      String method,
      Map<String, dynamic>? params, {
        bool passHeader = false,
        bool sendJson = false,
        Map<String, String>? extraHeaders,
        Duration timeout = const Duration(seconds: 30),
      }) async {
    // 1st attempt: klassisch mit Authorization Header
    final r1 = await _doHttp(
      uri: uri,
      method: method,
      params: params,
      passHeader: passHeader,
      sendJson: sendJson,
      extraHeaders: extraHeaders,
      timeout: timeout,
      forceQueryToken: false,
    );

    // Erfolgreich -> zurück
    if (r1.status) return r1;

    // Wenn 401 und typische Meldung -> 2nd attempt: Token als Query, ohne Auth-Header
    try {
      final body = r1.responseJson;
      if (_shouldFallbackWithQuery(body)) {

        return await _doHttp(
          uri: uri,
          method: method,
          params: params,
          passHeader: false, // WICHTIG: kein Authorization Header
          sendJson: sendJson,
          extraHeaders: extraHeaders,
          timeout: timeout,
          forceQueryToken: true,
        );
      }
    } catch (_) {}

    // sonst r1 (Fehler) zurück
    return r1;
  }

  Future<ResponseModel> _doHttp({
    required String uri,
    required String method,
    required Map<String, dynamic>? params,
    required bool passHeader,
    required bool sendJson,
    required Map<String, String>? extraHeaders,
    required Duration timeout,
    required bool forceQueryToken,
  }) async {
    http.Response response;

    final url = _buildUri(
      uri,
      method,
      params,
      forceQueryToken: forceQueryToken,
    );

    final headers = _baseHeaders(withAuth: passHeader, sendJson: sendJson)
      ..addAll(extraHeaders ?? const {});
    // Sicherheit: keine fremden Token-Header zulassen
    headers.removeWhere((k, _) => _isTokenKey(k));

    try {
      if (method == Method.postMethod) {
        response = await http
            .post(
          url,
          headers: headers,
          body: sendJson ? jsonEncode(params ?? {}) : params,
        )
            .timeout(timeout);
      } else if (method == Method.putMethod) {
        final putHeaders = Map<String, String>.from(headers);
        putHeaders.putIfAbsent(
          'Content-Type',
              () => sendJson
              ? 'application/json; charset=utf-8'
              : 'application/x-www-form-urlencoded; charset=UTF-8',
        );
        response = await http
            .put(
          url,
          headers: putHeaders,
          body: sendJson ? jsonEncode(params ?? {}) : params,
        )
            .timeout(timeout);
      } else if (method == Method.deleteMethod) {
        response = await http.delete(url, headers: headers).timeout(timeout);
      } else {
        response = await http.get(url, headers: headers).timeout(timeout);
      }

      if (kDebugMode) {
        final redactedAuth = _redactAuth(headers['Authorization']);
        final redactedHeaders = Map<String, String>.from(headers);
        if (headers.containsKey('Authorization')) {
          redactedHeaders['Authorization'] = redactedAuth;
        }
        debugPrint('====> URL: $url');
        debugPrint('====> METHOD: $method');
        debugPrint('====> HEADERS: $redactedHeaders');
        debugPrint('====> PARAMS: ${sendJson ? jsonEncode(params) : params}');
        debugPrint('====> STATUS: ${response.statusCode}');
        debugPrint('====> BODY: ${response.body}');
      }

      StatusModel? model;
      try {
        final decoded = jsonDecode(response.body);
        model = StatusModel.fromJson(decoded);
      } catch (_) {
        // kein StatusModel – ist ok
      }

      if (response.statusCode == 200) {
        if (model?.status == false) {
          await _forceLogout();
        }
        return ResponseModel(true, (model?.message ?? '').tr, response.body);
      }

      if (response.statusCode == 401) {
        // NICHT sofort ausloggen – erst dem Aufrufer die Chance geben (Fallback etc.)
        return ResponseModel(false, (model?.message ?? '').tr, response.body);
      }

      if (response.statusCode == 404) {
        return ResponseModel(false, (model?.message ?? '').tr, response.body);
      }

      if (response.statusCode >= 500) {
        return ResponseModel(
          false,
          (model?.message?.tr ?? LocalStrings.serverError.tr),
          response.body,
        );
      }

      return ResponseModel(
        false,
        (model?.message?.tr ?? LocalStrings.somethingWentWrong.tr),
        response.body,
      );
    } on SocketException {
      return ResponseModel(false, LocalStrings.somethingWentWrong.tr, '');
    } on FormatException {
      await _forceLogout();
      return ResponseModel(false, LocalStrings.badResponseMsg.tr, '');
    } on TimeoutException {
      return ResponseModel(false, LocalStrings.somethingWentWrong.tr, '');
    } catch (e) {
      return ResponseModel(false, e.toString(), '');
    }
  }

  Future<void> _forceLogout() async {
    await sharedPreferences.setBool(SharedPreferenceHelper.rememberMeKey, false);
    await sharedPreferences.remove(SharedPreferenceHelper.accessTokenKey);
    _token = '';
    if (Get.currentRoute != RouteHelper.loginScreen) {
      Get.offAllNamed(RouteHelper.loginScreen);
    }
  }
}
