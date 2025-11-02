import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/method.dart';
import 'package:flutex_admin/core/utils/url_container.dart';

class NotificationRepo {
  ApiClient apiClient;
  NotificationRepo({required this.apiClient});

  Future<ResponseModel> getAllNotifications() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.notificationsUrl}";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }
}
