import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/method.dart';
import 'package:flutex_admin/core/utils/url_container.dart';
import 'package:flutex_admin/features/staff/model/staff_post_model.dart';

class StaffRepo {
  final ApiClient apiClient;
  StaffRepo({required this.apiClient});

  Future<ResponseModel> getAllStaffs() async {
    final url = "${UrlContainer.baseUrl}${UrlContainer.staffsUrl}";
    return await apiClient.request(url, Method.getMethod, null, passHeader: true);
  }

  Future<ResponseModel> getStaffDetails(staffId) async {
    final url = "${UrlContainer.baseUrl}${UrlContainer.staffsUrl}/id/$staffId";
    return await apiClient.request(url, Method.getMethod, null, passHeader: true);
  }

  Future<StatusModel> submitStaff(
      StaffPostModel staffModel, {
        String? staffId,
        bool isUpdate = false,
      }) async {
    final base = "${UrlContainer.baseUrl}${UrlContainer.staffsUrl}";
    final url = isUpdate ? "$base/id/$staffId" : base;

    final req = http.MultipartRequest(isUpdate ? 'PUT' : 'POST', Uri.parse(url));

    // Token IMMER über Authorization-Header senden
    final auth = apiClient.authorizationHeaderValue;
    if (auth.isNotEmpty) {
      req.headers['Authorization'] = auth;
    }

    // Felder
    req.fields.addAll({
      "firstname": staffModel.firstName,
      "lastname": staffModel.lastName,
      "email": staffModel.email,
      "phonenumber": staffModel.phoneNumber ?? '',
      "hourly_rate": staffModel.hourlyRate ?? '',
      "facebook": staffModel.facebook ?? '',
      "skype": staffModel.skype ?? '',
      "linkedin": staffModel.linkedIn ?? '',
      "password": staffModel.password,
      "is_not_staff": staffModel.isNotStaff ?? '',
      "admin": staffModel.admin ?? '',
      "send_welcome_email": staffModel.sendWelcomeEmail ?? '',
    });

    // Bild (optional)
    if (staffModel.image != null) {
      req.files.add(
        http.MultipartFile(
          'profile_image',
          staffModel.image!.readAsBytes().asStream(),
          staffModel.image!.lengthSync(),
          filename: staffModel.image!.path.split('/').last,
        ),
      );
    }

    try {
      final streamed = await req.send();
      final body = await streamed.stream.bytesToString();

      if (kDebugMode) {
        print('STAFF SUBMIT => ${streamed.statusCode}  METHOD=${req.method}');
        print('HEADERS      => ${req.headers}');
        print('FIELDS       => ${req.fields}');
        print('BODY         => $body');
      }

      try {
        return StatusModel.fromJson(jsonDecode(body));
      } catch (_) {
        return StatusModel(status: streamed.statusCode == 200, message: body);
      }
    } catch (e) {
      if (kDebugMode) {
        print('STAFF SUBMIT ERROR => $e');
      }
      return StatusModel(status: false, message: e.toString());
    }
  }

  Future<ResponseModel> deleteStaff(staffId, transferDataTo) async {
    final url =
        "${UrlContainer.baseUrl}${UrlContainer.staffsUrl}/id/$staffId/transfer_data_to/$transferDataTo";
    return await apiClient.request(url, Method.deleteMethod, null, passHeader: true);
  }

  Future<ResponseModel> searchStaff(keysearch) async {
    final url = "${UrlContainer.baseUrl}${UrlContainer.staffsUrl}/search/$keysearch";
    return await apiClient.request(url, Method.getMethod, null, passHeader: true);
  }
}