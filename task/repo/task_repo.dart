import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/method.dart';
import 'package:flutex_admin/core/utils/url_container.dart';
import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/features/task/model/task_create_model.dart';

class TaskRepo {
  ApiClient apiClient;
  TaskRepo({required this.apiClient});

  Future<ResponseModel> getAllTasks({
    int page = 0,
    String? sort,
    String? priority,
    String? status,
  }) async {
    // Calculate offset based on page number
    int offset = page * int.parse(UrlContainer.limit);
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.tasksUrl}?limit=${UrlContainer.limit}&offset=$offset";
    sort != null ? url += "&sort=$sort" : null;
    status != null ? url += "&status=$status" : null;
    priority != null ? url += "&priority=$priority" : null;
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> getTaskDetails(taskId) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.tasksUrl}/id/$taskId";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> getAllCustomers() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.customersUrl}";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> getAllProjects() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.projectsUrl}";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> getAllInvoices() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.invoicesUrl}";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> getAllLeads() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.leadsUrl}";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> getAllContracts() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.contractsUrl}";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> getAllEstimates() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.estimatesUrl}";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> getAllProposals() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.proposalsUrl}";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> createTask(
    TaskCreateModel taskModel, {
    String? taskId,
    bool isUpdate = false,
  }) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.tasksUrl}";

    Map<String, dynamic> params = {
      "name": taskModel.subject,
      "startdate": taskModel.startDate,
      "is_public": taskModel.isPublic,
      "billable": taskModel.billable,
      "hourly_rate": taskModel.hourlyRate,
      "duedate": taskModel.dueDate,
      "priority": taskModel.priority,
      "repeat_every": '',
      "rel_type": taskModel.relType,
      "rel_id": taskModel.relId,
      "tags": taskModel.tags,
      "description": taskModel.description,
    };

    ResponseModel responseModel = await apiClient.request(
      isUpdate ? '$url/id/$taskId' : url,
      isUpdate ? Method.putMethod : Method.postMethod,
      params,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> deleteTask(taskId) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.tasksUrl}/id/$taskId";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.deleteMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> searchTask(keysearch) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.tasksUrl}/search/$keysearch";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }
}
