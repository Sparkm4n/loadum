import 'dart:async';
import 'dart:convert';
import 'package:flutex_admin/common/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutex_admin/common/models/settings_model.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/common/models/currencies_model.dart';
import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/features/customer/model/customer_model.dart';
import 'package:flutex_admin/features/item/model/item_model.dart';
import 'package:flutex_admin/features/lead/model/lead_model.dart';
import 'package:flutex_admin/features/proposal/model/proposal_details_model.dart';
import 'package:flutex_admin/features/proposal/model/proposal_item_model.dart';
import 'package:flutex_admin/features/proposal/model/proposal_model.dart';
import 'package:flutex_admin/features/proposal/model/proposal_post_model.dart';
import 'package:flutex_admin/features/proposal/repo/proposal_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProposalController extends GetxController {
  ProposalRepo proposalRepo;
  ProposalController({required this.proposalRepo});

  bool isLoading = true;
  bool isSubmitLoading = false;
  ProposalsModel proposalsModel = ProposalsModel();
  ProposalDetailsModel proposalDetailsModel = ProposalDetailsModel();
  SettingsModel settingsModel = SettingsModel();
  CustomersModel customersModel = CustomersModel();
  LeadsModel leadsModel = LeadsModel();
  CurrenciesModel currenciesModel = CurrenciesModel();
  ItemsModel itemsModel = ItemsModel();
  List<ProposalItemModel> proposalItemList = [];
  List<String> removedItemsList = [];

  final Map<String, String> proposalStatus = {
    '1': LocalStrings.open.tr,
    '2': LocalStrings.declined.tr,
    '3': LocalStrings.accepted.tr,
    '4': LocalStrings.sent.tr,
    '5': LocalStrings.revised.tr,
    '6': LocalStrings.draft.tr,
  };

  final Map<String, String> proposalRelated = {
    'lead': LocalStrings.lead.tr,
    'customer': LocalStrings.customer.tr,
  };

  Future<void> initialData({bool shouldLoad = true}) async {
    isLoading = shouldLoad ? true : false;
    update();

    await loadProposals();
    isLoading = false;
    update();
  }

  Future<void> loadProposals() async {
    ResponseModel responseModel = await proposalRepo.getAllProposals();
    proposalsModel = ProposalsModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
    isLoading = false;
    update();
  }

  Future<void> loadProposalDetails(proposalId) async {
    ResponseModel responseModel = await proposalRepo.getProposalDetails(
      proposalId,
    );
    proposalDetailsModel = ProposalDetailsModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );

    isLoading = false;
    update();
  }

  Future<void> loadProposalCreateData() async {
    ResponseModel responseModel = await proposalRepo.getSettingsData();
    settingsModel = SettingsModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
    //numberController.text = settingsModel.data?.proposalNumberPrefix ?? '';
    isLoading = false;
    update();
  }

  Future<CustomersModel> loadCustomers() async {
    ResponseModel responseModel = await proposalRepo.getAllCustomers();
    return customersModel = CustomersModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
  }

  Future<LeadsModel> loadLeads() async {
    ResponseModel responseModel = await proposalRepo.getAllLeads();
    return leadsModel = LeadsModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
  }

  Future<CurrenciesModel> loadCurrencies() async {
    ResponseModel responseModel = await proposalRepo.getCurrencies();
    return currenciesModel = CurrenciesModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
  }

  Future<ItemsModel> loadItems() async {
    ResponseModel responseModel = await proposalRepo.getItems();
    return itemsModel = ItemsModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
  }

  Future<void> loadProposalUpdateData(proposalId) async {
    ResponseModel responseModel = await proposalRepo.getProposalDetails(
      proposalId,
    );
    if (responseModel.status) {
      proposalDetailsModel = ProposalDetailsModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
      ResponseModel settingsResponseModel = await proposalRepo
          .getSettingsData();
      settingsModel = SettingsModel.fromJson(
        jsonDecode(settingsResponseModel.responseJson),
      );
      subjectController.text = proposalDetailsModel.data?.subject ?? '';
      proposalRelatedController.text = proposalDetailsModel.data?.relType ?? '';
      clientController.text = proposalDetailsModel.data?.relId ?? '';
      clientNameController.text = proposalDetailsModel.data?.proposalTo ?? '';
      clientEmailController.text = proposalDetailsModel.data?.email ?? '';
      dateController.text = proposalDetailsModel.data?.date ?? '';
      openTillController.text = proposalDetailsModel.data?.openTill ?? '';
      statusController.text = proposalDetailsModel.data?.status ?? '';
      currencyController.text = proposalDetailsModel.data?.currencyId ?? '';
      totalProposalAmount = proposalDetailsModel.data?.total ?? '';

      // Items
      removedItemsList.clear();
      proposalItemList.clear();
      if (proposalDetailsModel.data!.items!.length > 1) {
        for (var i = 0; i < proposalDetailsModel.data!.items!.length; i++) {
          proposalItemList.add(
            ProposalItemModel(
              itemNameController: TextEditingController(
                text: proposalDetailsModel.data!.items![i].description
                    .toString(),
              ),
              descriptionController: TextEditingController(
                text: proposalDetailsModel.data!.items![i].longDescription
                    .toString(),
              ),
              qtyController: TextEditingController(
                text: proposalDetailsModel.data!.items![i].qty.toString(),
              ),
              unitController: TextEditingController(
                text: proposalDetailsModel.data!.items![i].unit.toString(),
              ),
              rateController: TextEditingController(
                text: proposalDetailsModel.data!.items![i].rate.toString(),
              ),
            ),
          );
        }
      }
      for (var i = 0; i < proposalDetailsModel.data!.items!.length; i++) {
        removedItemsList.add(
          proposalDetailsModel.data!.items![i].id.toString(),
        );
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isLoading = false;
    update();
  }

  TextEditingController subjectController = TextEditingController();
  TextEditingController proposalRelatedController = TextEditingController();
  TextEditingController clientController = TextEditingController();
  TextEditingController clientNameController = TextEditingController();
  TextEditingController clientEmailController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController openTillController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController currencyController = TextEditingController();

  TextEditingController itemController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController rateController = TextEditingController();

  FocusNode subjectFocusNode = FocusNode();
  FocusNode clientNameFocusNode = FocusNode();
  FocusNode clientEmailFocusNode = FocusNode();
  FocusNode clientFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();
  FocusNode openTillFocusNode = FocusNode();

  FocusNode itemFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode qtyFocusNode = FocusNode();
  FocusNode unitFocusNode = FocusNode();
  FocusNode rateFocusNode = FocusNode();

  void increaseItemField() {
    proposalItemList.add(
      ProposalItemModel(
        itemNameController: TextEditingController(text: itemController.text),
        descriptionController: TextEditingController(
          text: descriptionController.text,
        ),
        qtyController: TextEditingController(text: qtyController.text),
        unitController: TextEditingController(text: unitController.text),
        rateController: TextEditingController(text: rateController.text),
      ),
    );
    itemController.clear();
    descriptionController.clear();
    qtyController.clear();
    unitController.clear();
    rateController.clear();
    calculateProposalAmount();
    update();
  }

  void decreaseItemField(int index) {
    proposalItemList.removeAt(index);
    calculateProposalAmount();
    update();
  }

  String totalProposalAmount = '';

  void calculateProposalAmount() {
    double totalAmount = 0;

    for (var proposal in proposalItemList) {
      double proposalAmount =
          double.tryParse(proposal.rateController.text) ?? 0;
      double proposalQty = double.tryParse(proposal.qtyController.text) ?? 0;
      totalAmount = totalAmount + (proposalAmount * proposalQty);
    }

    totalProposalAmount = totalAmount.toString();

    update();
  }

  Future<void> submitProposal({
    String? proposalId,
    bool isUpdate = false,
  }) async {
    String subject = subjectController.text.toString();
    String related = proposalRelatedController.text.toString();
    String client = clientController.text.toString();
    String clientName = clientNameController.text.toString();
    String clientEmail = clientEmailController.text.toString();
    String date = dateController.text.toString();
    String openTill = openTillController.text.toString();
    String currency = currencyController.text.toString();
    String status = statusController.text.toString();

    if (subject.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.enterSubject.tr]);
      return;
    }

    if (clientName.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.enterName.tr]);
      return;
    }

    if (related.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.enterName.tr]);
      return;
    }

    if (clientEmail.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.enterEmail.tr]);
      return;
    }

    if (client.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.selectClient.tr]);
      return;
    }

    if (date.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.enterStartDate.tr]);
      return;
    }

    if (status.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.selectStatus.tr]);
      return;
    }

    if (currency.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.selectCurrency.tr]);
      return;
    }

    if (proposalItemList.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.pleaseAddItem.tr]);
      return;
    }

    isSubmitLoading = true;
    update();

    ProposalPostModel proposalModel = ProposalPostModel(
      subject: subject,
      related: related,
      relId: client,
      proposalTo: clientName,
      email: clientEmail,
      date: date,
      openTill: openTill,
      status: status,
      currency: currency,
      newItems: proposalItemList,
      removedItems: removedItemsList,
      subtotal: totalProposalAmount,
      total: totalProposalAmount,
    );

    ResponseModel responseModel = await proposalRepo.createProposal(
      proposalModel,
      proposalId: proposalId,
      isUpdate: isUpdate,
    );
    if (responseModel.status) {
      Get.back();
      if (isUpdate) await loadProposalDetails(proposalId);
      clearData();
      await initialData();
      CustomSnackBar.success(successList: [responseModel.message.tr]);
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
      return;
    }

    isSubmitLoading = false;
    update();
  }

  // Delete Proposal
  Future<void> deleteProposal(proposalId) async {
    ResponseModel responseModel = await proposalRepo.deleteProposal(proposalId);

    isSubmitLoading = true;
    update();

    if (responseModel.status) {
      await initialData();
      CustomSnackBar.success(successList: [responseModel.message.tr]);
    } else {
      CustomSnackBar.error(errorList: [(responseModel.message.tr)]);
    }

    isSubmitLoading = false;
    update();
  }

  // Search Proposals
  TextEditingController searchController = TextEditingController();
  String keysearch = "";

  Future<void> searchProposal() async {
    keysearch = searchController.text;
    ResponseModel responseModel = await proposalRepo.searchProposal(keysearch);
    if (responseModel.status) {
      proposalsModel = ProposalsModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isLoading = false;
    update();
  }

  bool isSearch = false;
  void changeSearchIcon() {
    isSearch = !isSearch;
    update();

    if (!isSearch) {
      searchController.clear();
      initialData();
    }
  }

  void clearData() {
    isLoading = false;
    isSubmitLoading = false;
    subjectController.text = '';
    proposalRelatedController.text = '';
    clientNameController.text = '';
    clientEmailController.text = '';
    clientController.text = '';
    dateController.text = '';
    openTillController.text = '';
    statusController.text = '';
    currencyController.text = '';

    itemController.text = '';
    descriptionController.text = '';
    qtyController.text = '';
    unitController.text = '';
    rateController.text = '';

    proposalItemList.clear();
  }
}
