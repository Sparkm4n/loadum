import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/method.dart';
import 'package:flutex_admin/core/utils/url_container.dart';
import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/features/proposal/model/proposal_post_model.dart';

class ProposalRepo {
  ApiClient apiClient;
  ProposalRepo({required this.apiClient});

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

  Future<ResponseModel> getProposalDetails(proposalId) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.proposalsUrl}/id/$proposalId";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> getSettingsData() async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.miscellaneousUrl}/general";
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

  Future<ResponseModel> getCurrencies() async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.miscellaneousUrl}/currencies";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> getItems() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.itemsUrl}";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> createProposal(
    ProposalPostModel proposalModel, {
    String? proposalId,
    bool isUpdate = false,
  }) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.proposalsUrl}";

    Map<String, dynamic> params = {
      "subject": proposalModel.subject,
      "rel_type": proposalModel.related,
      "rel_id": proposalModel.relId,
      "proposal_to": proposalModel.proposalTo,
      "date": proposalModel.date,
      "open_till": proposalModel.openTill,
      "currency": proposalModel.currency,
      //"discount_type": proposalModel.discountType,
      "status": proposalModel.status,
      //"assigned": proposalModel.assigned,
      "email": proposalModel.email,
      "subtotal": proposalModel.subtotal,
      "total": proposalModel.total,
    };

    int i = 0;
    for (var proposal in proposalModel.newItems) {
      String proposalItemName = proposal.itemNameController.text;
      String proposalItemDescription = proposal.descriptionController.text;
      String proposalItemQty = proposal.qtyController.text;
      String proposalItemRate = proposal.rateController.text;
      String proposalItemUnit = proposal.unitController.text;

      if (proposalItemName.isNotEmpty && proposalItemRate.isNotEmpty) {
        params['newitems[$i][description]'] = proposalItemName;
        params['newitems[$i][long_description]'] = proposalItemDescription;
        params['newitems[$i][qty]'] = proposalItemQty;
        params['newitems[$i][rate]'] = proposalItemRate;
        params['newitems[$i][unit]'] = proposalItemUnit;
        //params['newitems[$i][order]'] = '1';
        //params['newitems[0][taxname][]'] = 'CGST|9.00';
        //params['newitems[0][taxname][]'] = 'SGST|9.00';
        i++;
      }
    }

    if (proposalModel.removedItems != null) {
      int r = 0;
      for (var removedItems in proposalModel.removedItems!) {
        params['removed_items[$r]'] = removedItems;
        r++;
      }
    }

    ResponseModel responseModel = await apiClient.request(
      isUpdate ? '$url/id/$proposalId' : url,
      isUpdate ? Method.putMethod : Method.postMethod,
      params,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> deleteProposal(proposalId) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.proposalsUrl}/id/$proposalId";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.deleteMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }

  Future<ResponseModel> searchProposal(keysearch) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.proposalsUrl}/search/$keysearch";
    ResponseModel responseModel = await apiClient.request(
      url,
      Method.getMethod,
      null,
      passHeader: true,
    );
    return responseModel;
  }
}
