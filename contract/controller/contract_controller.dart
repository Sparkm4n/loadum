import 'dart:async';
import 'dart:convert';
import 'package:flutex_admin/common/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/features/contract/model/contract_details_model.dart';
import 'package:flutex_admin/features/contract/model/contract_model.dart';
import 'package:flutex_admin/features/contract/model/contract_post_model.dart';
import 'package:flutex_admin/features/contract/repo/contract_repo.dart';
import 'package:flutex_admin/features/customer/model/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContractController extends GetxController {
  ContractRepo contractRepo;
  ContractController({required this.contractRepo});

  bool isLoading = true;
  bool isSubmitLoading = false;
  ContractsModel contractsModel = ContractsModel();
  ContractDetailsModel contractDetailsModel = ContractDetailsModel();
  CustomersModel customersModel = CustomersModel();

  Future<void> initialData({bool shouldLoad = true}) async {
    isLoading = shouldLoad ? true : false;
    update();

    await loadContracts();
    isLoading = false;
    update();
  }

  Future<void> loadContracts() async {
    ResponseModel responseModel = await contractRepo.getAllContracts();
    if (responseModel.status) {
      contractsModel =
          ContractsModel.fromJson(jsonDecode(responseModel.responseJson));
    } else {
      contractsModel = ContractsModel();
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    isLoading = false;
    update();
  }

  Future<void> loadContractDetails(contractId) async {
    ResponseModel responseModel =
        await contractRepo.getContractDetails(contractId);
    if (responseModel.status) {
      contractDetailsModel =
          ContractDetailsModel.fromJson(jsonDecode(responseModel.responseJson));
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isLoading = false;
    update();
  }

  Future<CustomersModel> loadCustomers() async {
    ResponseModel responseModel = await contractRepo.getAllCustomers();
    return customersModel =
        CustomersModel.fromJson(jsonDecode(responseModel.responseJson));
  }

  Future<void> loadContractUpdateData(contractId) async {
    ResponseModel responseModel =
        await contractRepo.getContractDetails(contractId);
    if (responseModel.status) {
      contractDetailsModel =
          ContractDetailsModel.fromJson(jsonDecode(responseModel.responseJson));
      subjectController.text = contractDetailsModel.data?.subject ?? '';
      clientController.text = contractDetailsModel.data?.userId ?? '';
      dateStartController.text = contractDetailsModel.data?.dateStart ?? '';
      dateEndController.text = contractDetailsModel.data?.dateEnd ?? '';
      contractValueController.text =
          contractDetailsModel.data?.contractValue ?? '';
      descriptionController.text = contractDetailsModel.data?.description ?? '';
      contentController.text = contractDetailsModel.data?.content ?? '';
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isLoading = false;
    update();
  }

  TextEditingController subjectController = TextEditingController();
  TextEditingController clientController = TextEditingController();
  TextEditingController dateStartController = TextEditingController();
  TextEditingController dateEndController = TextEditingController();
  TextEditingController contractValueController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  FocusNode subjectFocusNode = FocusNode();
  FocusNode clientFocusNode = FocusNode();
  FocusNode dateStartFocusNode = FocusNode();
  FocusNode dateEndFocusNode = FocusNode();
  FocusNode contractValueFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode contentFocusNode = FocusNode();

  Future<void> submitContract(
      {String? contractId, bool isUpdate = false}) async {
    String subject = subjectController.text.toString();
    String client = clientController.text.toString();
    String dateStart = dateStartController.text.toString();
    String dateEnd = dateEndController.text.toString();
    String contractValue = contractValueController.text.toString();
    String description = descriptionController.text.toString();
    String content = contentController.text.toString();

    if (subject.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.enterSubject.tr]);
    }
    if (dateStart.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.enterStartDate.tr]);
    }
    if (client.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.client.tr]);
    }

    isSubmitLoading = true;
    update();

    ContractPostModel contractModel = ContractPostModel(
      subject: subject,
      client: client,
      startDate: dateStart,
      endDate: dateEnd,
      contractValue: contractValue,
      description: description,
      content: content,
    );

    ResponseModel responseModel = await contractRepo.createContract(
        contractModel,
        contractId: contractId,
        isUpdate: isUpdate);
    if (responseModel.status) {
      Get.back();
      if (isUpdate) await loadContractDetails(contractId);
      await initialData();
      CustomSnackBar.success(successList: [responseModel.message.tr]);
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    isSubmitLoading = false;
    update();
  }

  // Delete Contract
  Future<void> deleteContract(contractId) async {
    ResponseModel responseModel = await contractRepo.deleteContract(contractId);

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

  void clearData() {
    isLoading = false;
    subjectController.text = '';
    clientController.text = '';
    dateStartController.text = '';
    dateEndController.text = '';
    contractValueController.text = '';
    descriptionController.text = '';
    contentController.text = '';
  }
}
