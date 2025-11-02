import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/method.dart';
import 'package:flutex_admin/core/utils/url_container.dart';
import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/features/ticket/model/ticket_create_model.dart';

class TicketRepo {
  ApiClient apiClient;
  TicketRepo({required this.apiClient});

  Future<ResponseModel> getAllTickets() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.ticketsUrl}";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getTicketDetails(ticketId) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.ticketsUrl}/id/$ticketId";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getAllCustomers() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.customersUrl}";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getCustomerContacts(customerId) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.contactsUrl}/id/$customerId";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getTicketDepartments() async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.miscellaneousUrl}/ticket_departments";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getTicketPriorities() async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.miscellaneousUrl}/ticket_priorities";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getTicketServices() async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.miscellaneousUrl}/ticket_services";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> createTicket(TicketCreateModel ticketModel,
      {String? ticketId, bool isUpdate = false}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.ticketsUrl}";

    Map<String, dynamic> params = {
      "subject": ticketModel.subject,
      "department": ticketModel.department,
      "priority": ticketModel.priority,
      "service": ticketModel.service,
      "userid": ticketModel.userId,
      "contactid": ticketModel.contactId,
      "message": ticketModel.description,
    };

    ResponseModel responseModel = await apiClient.request(
        isUpdate ? '$url/id/$ticketId' : url,
        isUpdate ? Method.putMethod : Method.postMethod,
        params,
        passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> deleteTicket(ticketId) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.ticketsUrl}/id/$ticketId";
    ResponseModel responseModel = await apiClient
        .request(url, Method.deleteMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> searchTicket(keysearch) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.ticketsUrl}/search/$keysearch";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }
}
