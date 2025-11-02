import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutex_admin/common/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/features/staff/model/staff_details_model.dart';
import 'package:flutex_admin/features/staff/model/staff_model.dart';
import 'package:flutex_admin/features/staff/model/staff_post_model.dart';
import 'package:flutex_admin/features/staff/repo/staff_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffController extends GetxController {
  StaffRepo staffRepo;
  StaffController({required this.staffRepo});

  bool isLoading = true;
  bool isSubmitLoading = false;
  StaffsModel staffsModel = StaffsModel();
  StaffsModel otherStaffsModel = StaffsModel();
  StaffDetailsModel staffDetailsModel = StaffDetailsModel();
  String currentStaffId = '';
  String transferDataTo = '';

  Future<void> initialData({bool shouldLoad = true}) async {
    isLoading = shouldLoad ? true : false;
    update();
    transferDataTo = '';
    await loadStaff();
    isLoading = false;
    update();
  }

  Future<void> loadStaff() async {
    ResponseModel responseModel = await staffRepo.getAllStaffs();
    staffsModel = StaffsModel.fromJson(jsonDecode(responseModel.responseJson));
    isLoading = false;
    update();
  }

  Future<StaffsModel> loadOtherStaff() async {
    ResponseModel responseModel = await staffRepo.getAllStaffs();
    otherStaffsModel = StaffsModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
    otherStaffsModel.data?.removeWhere((staff) => staff.id == currentStaffId);
    return otherStaffsModel;
  }

  Future<void> loadStaffDetails(staffId) async {
    ResponseModel responseModel = await staffRepo.getStaffDetails(staffId);
    if (responseModel.status) {
      staffDetailsModel = StaffDetailsModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
      currentStaffId = staffDetailsModel.data?.id ?? '';
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    isLoading = false;
    update();
  }

  Future<void> loadStaffUpdateData(staffId) async {
    ResponseModel responseModel = await staffRepo.getStaffDetails(staffId);
    if (responseModel.status) {
      staffDetailsModel = StaffDetailsModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
      firstNameController.text = staffDetailsModel.data?.firstName ?? '';
      lastNameController.text = staffDetailsModel.data?.lastName ?? '';
      phoneNumberController.text = staffDetailsModel.data?.phoneNumber ?? '';
      emailController.text = staffDetailsModel.data?.email ?? '';
      hourlyRateController.text = staffDetailsModel.data?.hourlyRate ?? '';
      facebookController.text = staffDetailsModel.data?.facebook ?? '';
      linkedInController.text = staffDetailsModel.data?.linkedin ?? '';
      skypeController.text = staffDetailsModel.data?.skype ?? '';
      imageUrl = staffDetailsModel.data?.profileImage ?? '';
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    isLoading = false;
    update();
  }

  bool notStaffMember = false;
  changeNotStaffMember() {
    notStaffMember = !notStaffMember;
    update();
  }

  bool isAdministrator = false;
  changeIsAdministrator() {
    isAdministrator = !isAdministrator;
    notStaffMember = false;
    update();
  }

  bool sendWelcomeEmail = false;
  changeSendWelcomeEmail() {
    sendWelcomeEmail = !sendWelcomeEmail;
    update();
  }

  String imageUrl = '';
  File? imageFile;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController hourlyRateController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController linkedInController = TextEditingController();
  TextEditingController skypeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode facebookFocusNode = FocusNode();
  FocusNode linkedInFocusNode = FocusNode();
  FocusNode skypeFocusNode = FocusNode();
  FocusNode hourlyRateFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  Future<void> submitStaff({String? staffId, bool isUpdate = false}) async {
    String firstName = firstNameController.text.toString();
    String lastName = lastNameController.text.toString();
    String email = emailController.text.toString();
    String password = passwordController.text.toString();

    if (firstName.isEmpty) {
      CustomSnackBar.error(
        errorList: [
          '${LocalStrings.firstName.tr} ${LocalStrings.isRequired.tr}',
        ],
      );
      return;
    }
    if (lastName.isEmpty) {
      CustomSnackBar.error(
        errorList: [
          '${LocalStrings.lastName.tr} ${LocalStrings.isRequired.tr}',
        ],
      );
      return;
    }
    if (email.isEmpty) {
      CustomSnackBar.error(
        errorList: ['${LocalStrings.email.tr} ${LocalStrings.isRequired.tr}'],
      );
      return;
    }
    if (password.isEmpty) {
      CustomSnackBar.error(
        errorList: [
          '${LocalStrings.password.tr} ${LocalStrings.isRequired.tr}',
        ],
      );
      return;
    }

    isSubmitLoading = true;
    update();

    StaffPostModel staffPostModel = StaffPostModel(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      phoneNumber: phoneNumberController.text.toString(),
      hourlyRate: hourlyRateController.text.toString(),
      facebook: facebookController.text.toString(),
      linkedIn: linkedInController.text.toString(),
      skype: skypeController.text.toString(),
      isNotStaff: notStaffMember ? '1' : '0',
      admin: isAdministrator ? '1' : '0',
      sendWelcomeEmail: sendWelcomeEmail ? '1' : '0',
      image: imageFile,
    );

    StatusModel responseModel = await staffRepo.submitStaff(
      staffPostModel,
      staffId: staffId,
      isUpdate: isUpdate,
    );
    if (responseModel.status ?? false) {
      clearStaffData();
      Get.back();
      if (isUpdate) await loadStaffDetails(staffId);
      await initialData();
      CustomSnackBar.success(successList: [responseModel.message!.tr]);
    } else {
      CustomSnackBar.error(errorList: [responseModel.message!.tr]);
    }

    isSubmitLoading = false;
    update();
  }

  // Delete Staff
  Future<void> deleteStaff() async {
    if (transferDataTo.isEmpty) {
      CustomSnackBar.error(
        errorList: [
          '${LocalStrings.transferDataTo.tr} ${LocalStrings.isRequired.tr}',
        ],
      );
      return;
    }
    ResponseModel responseModel = await staffRepo.deleteStaff(
      currentStaffId,
      transferDataTo,
    );

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

  // Search Staffs
  TextEditingController searchController = TextEditingController();
  String keysearch = "";

  Future<void> searchStaff() async {
    keysearch = searchController.text;
    ResponseModel responseModel = await staffRepo.searchStaff(keysearch);
    if (responseModel.status) {
      staffsModel = StaffsModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
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

  void clearStaffData() {
    isLoading = false;
    isSubmitLoading = false;
    isAdministrator = false;
    notStaffMember = false;
    sendWelcomeEmail = false;
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneNumberController.clear();
    hourlyRateController.clear();
    facebookController.clear();
    linkedInController.clear();
    skypeController.clear();
    imageUrl = '';
    passwordController.clear();
  }
}
