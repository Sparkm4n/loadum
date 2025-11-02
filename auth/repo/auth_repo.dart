// lib/features/auth/repo/auth_repo.dart
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform, debugPrint;
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/method.dart';
import 'package:flutex_admin/core/utils/url_container.dart';
import 'package:flutex_admin/common/models/response_model.dart';

class AuthRepo {
  final ApiClient apiClient;
  AuthRepo({required this.apiClient});

  Future<ResponseModel> loginUser(String email, String password) async {
    final map = <String, String>{
      'email': email.trim(),
      'password': password,
    };
    final url = '${UrlContainer.baseUrl}${UrlContainer.loginUrl}';
    return await apiClient.request(
      url,
      Method.postMethod,
      map,
      passHeader: false,
      sendJson: false,
    );
  }

  /// Web: wir lassen FCM aus (Policy/ServiceWorker).
  Future<ResponseModel> updateToken() async {
    if (kIsWeb) {
      debugPrint('ℹ️ Web detected: skip /auth/firebase-token call.');
      return ResponseModel(true, 'FCM skipped on web', '');
    }

    String? deviceToken;
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true,
      );
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true, badge: true, sound: true,
        announcement: false, carPlay: false, criticalAlert: false, provisional: false,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        deviceToken = await getDeviceToken();
      }
    } else {
      deviceToken = await getDeviceToken();
    }

    try {
      await FirebaseMessaging.instance.subscribeToTopic(LocalStrings.topic);
    } catch (_) {}

    deviceToken ??= '@';

    final map = <String, String>{'fcm_token': deviceToken};
    final url = '${UrlContainer.baseUrl}${UrlContainer.tokenUrl}';
    return await apiClient.request(
      url,
      Method.postMethod,
      map,
      passHeader: true,  // wir haben jetzt ein normales API-Token
      sendJson: true,    // JSON senden
    );
  }

  Future<String?> getDeviceToken() async {
    try {
      final t = await FirebaseMessaging.instance.getToken();
      if (t != null && t.isNotEmpty) debugPrint('✅ Device FCM Token: $t');
      return t;
    } catch (e) {
      debugPrint('❌ Device Token Error: $e');
      return null;
    }
  }

  Future<ResponseModel> forgetPassword(String email) async {
    final map = <String, String>{'email': email.trim()};
    final url = '${UrlContainer.baseUrl}${UrlContainer.forgotPasswordUrl}';
    return await apiClient.request(
      url,
      Method.postMethod,
      map,
      passHeader: false,
      sendJson: false,
    );
  }
}
