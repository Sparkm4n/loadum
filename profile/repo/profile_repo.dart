import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/method.dart';
import 'package:flutex_admin/core/utils/url_container.dart';
import 'package:flutex_admin/features/profile/model/profile_update_model.dart';

class ProfileRepo {
  final ApiClient apiClient;
  ProfileRepo({required this.apiClient});

  Future<ResponseModel> getData() async {
    final url = "${UrlContainer.baseUrl}${UrlContainer.profileUrl}";
    return await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
  }

  Future<StatusModel> updateProfile(ProfileUpdateModel profileUpdateModel) async {
    final url = "${UrlContainer.baseUrl}${UrlContainer.profileUrl}";
    final req = http.MultipartRequest('POST', Uri.parse(url));

    // Token IMMER über Authorization-Header senden
    final auth = apiClient.authorizationHeaderValue;
    if (auth.isNotEmpty) {
      req.headers['Authorization'] = auth;
    }

    // Felder
    req.fields.addAll({
      "firstname": profileUpdateModel.firstName,
      "lastname": profileUpdateModel.lastName,
      "phonenumber": profileUpdateModel.phoneNumber ?? '',
      "facebook": profileUpdateModel.facebook ?? '',
      "linkedin": profileUpdateModel.linkedin ?? '',
      "skype": profileUpdateModel.skype ?? '',
    });

    // Bild (optional)
    if (profileUpdateModel.image != null) {
      req.files.add(
        http.MultipartFile(
          'profile_image',
          profileUpdateModel.image!.readAsBytes().asStream(),
          profileUpdateModel.image!.lengthSync(),
          filename: profileUpdateModel.image!.path.split('/').last,
        ),
      );
    }

    try {
      final streamed = await req.send();
      final body = await streamed.stream.bytesToString();

      if (kDebugMode) {
        print('PROFILE UPDATE => ${streamed.statusCode}');
        print('HEADERS => ${req.headers}');
        print('FIELDS  => ${req.fields}');
        print('BODY    => $body');
      }

      // Versuche StatusModel zu parsen, fallback bei Fehlern
      try {
        return StatusModel.fromJson(jsonDecode(body));
      } catch (_) {
        return StatusModel(status: streamed.statusCode == 200, message: body);
      }
    } catch (e) {
      if (kDebugMode) {
        print('PROFILE UPDATE ERROR => $e');
      }
      return StatusModel(status: false, message: e.toString());
    }
  }
}