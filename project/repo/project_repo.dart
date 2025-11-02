import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/method.dart';
import 'package:flutex_admin/core/utils/url_container.dart';
import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/features/project/model/project_post_model.dart';

class ProjectRepo {
  ApiClient apiClient;
  ProjectRepo({required this.apiClient});

  Future<ResponseModel> getAllProjects() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.projectsUrl}";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getProjectDetails(projectId) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.projectsUrl}/id/$projectId";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getProjectGroup(projectId, group) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.projectsUrl}/id/$projectId/group/$group";
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

  Future<ResponseModel> createProject(ProjectPostModel projectModel,
      {String? projectId, bool isUpdate = false}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.projectsUrl}";

    Map<String, dynamic> params = {
      "name": projectModel.name,
      "clientid": projectModel.clientId,
      "billing_type": projectModel.billingType,
      "start_date": projectModel.startDate,
      "status": projectModel.status,
      "progress_from_tasks": projectModel.progressFromTasks,
      "project_cost": projectModel.projectCost,
      "progress": projectModel.progress,
      "project_rate_per_hour": projectModel.projectRatePerHour,
      "estimated_hours": projectModel.estimatedHours,
      "project_members": projectModel.projectMembers,
      "deadline": projectModel.deadline,
      "tags": projectModel.tags,
      "description": projectModel.description,
    };

    ResponseModel responseModel = await apiClient.request(
        isUpdate ? '$url/id/$projectId' : url,
        isUpdate ? Method.putMethod : Method.postMethod,
        params,
        passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> deleteProject(projectId) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.projectsUrl}/id/$projectId";
    ResponseModel responseModel = await apiClient
        .request(url, Method.deleteMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> searchProject(keysearch) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.projectsUrl}/search/$keysearch";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }
}
