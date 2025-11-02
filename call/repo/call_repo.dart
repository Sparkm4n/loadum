import 'dart:convert';
import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/method.dart';
import 'package:flutex_admin/core/utils/url_container.dart';

class CallRepo {
  final ApiClient apiClient;
  CallRepo({required this.apiClient});

  Future<ResponseModel> getAccessToken() async {
    final url = "${UrlContainer.baseUrl}/voice/token";
    return await apiClient.request(url, Method.getMethod, null, passHeader: true);
  }
  // Dummy – ersetze durch echte API.
  Future<List<String>> fetchOutboundNumbers() async {
    // Beispiel: vom Backend holen
    // final res = await apiClient.getData('/voice/outbound-numbers');
    // return (res.body['numbers'] as List).cast<String>();

    return ['Company default', '+1 415 555 0001', '+1 917 555 0022'];
  }
}