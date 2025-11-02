import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/method.dart';
import 'package:flutex_admin/core/utils/url_container.dart';
import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/features/expense/model/expense_post_model.dart';

class ExpenseRepo {
  ApiClient apiClient;
  ExpenseRepo({required this.apiClient});

  Future<ResponseModel> getAllExpenses() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.expensesUrl}";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> getExpenseDetails(expenseId) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.expensesUrl}/id/$expenseId";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> searchExpense(keysearch) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.expensesUrl}/search/$keysearch";
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

  Future<ResponseModel> getExpenseCategory() async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.miscellaneousUrl}/expense_categories";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> createExpense(
    ExpensePostModel expenseModel, {
    String? expenseId,
    bool isUpdate = false,
  }) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.expensesUrl}";

    Map<String, dynamic> params = {
      "expense_name": expenseModel.name,
      "note": expenseModel.note,
      "category": expenseModel.category,
      "date": expenseModel.date,
      "amount": expenseModel.amount,
      "clientid": expenseModel.customerId,
    };

    ResponseModel responseModel = await apiClient.request(
      isUpdate ? '$url/id/$expenseId' : url,
      isUpdate ? Method.putMethod : Method.postMethod,
      params,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> deleteExpense(expenseId) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.expensesUrl}/id/$expenseId";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.deleteMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }
}
