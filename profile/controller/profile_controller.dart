import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutex_admin/common/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/features/dashboard/controller/dashboard_controller.dart';
import 'package:flutex_admin/features/profile/model/profile_model.dart';
import 'package:flutex_admin/features/profile/model/profile_update_model.dart';
import 'package:flutex_admin/features/profile/repo/profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  ProfileRepo profileRepo;
  ProfileController({required this.profileRepo});

  bool isLoading = true;
  bool isSubmitLoading = false;
  ProfileModel profileModel = ProfileModel();

  Future<void> initialData({bool shouldLoad = true}) async {
    isLoading = shouldLoad ? true : false;
    update();

    await loadData();
    isLoading = false;
    update();
  }

  Future<dynamic> loadData() async {
    ResponseModel responseModel = await profileRepo.getData();
    if (responseModel.status) {
      profileModel = ProfileModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    isLoading = false;
    update();
  }

  String imageUrl = '';
  File? imageFile;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController linkedinController = TextEditingController();
  TextEditingController skypeController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();

  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode facebookFocusNode = FocusNode();
  FocusNode linkedinFocusNode = FocusNode();
  FocusNode skypeFocusNode = FocusNode();
  FocusNode mobileNoFocusNode = FocusNode();

  void loadProfileEditInfo() {
    firstNameController.text = profileModel.data?.firstName ?? '';
    lastNameController.text = profileModel.data?.lastName ?? '';
    emailController.text = profileModel.data?.email ?? '';
    emailController.text = profileModel.data?.facebook ?? '';
    emailController.text = profileModel.data?.linkedin ?? '';
    emailController.text = profileModel.data?.skype ?? '';
    mobileNoController.text = profileModel.data?.phoneNumber ?? '';
    imageUrl = profileModel.data?.profileImage ?? '';
    update();
  }

  Future<void> updateProfile() async {
    String firstName = firstNameController.text.toString();
    String lastName = lastNameController.text.toString();

    if (firstName.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.enterFirstName.tr]);
      return;
    }
    if (lastName.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.enterLastName.tr]);
      return;
    }

    isSubmitLoading = true;
    update();

    ProfileUpdateModel profileUpdateModel = ProfileUpdateModel(
      firstName: firstName,
      lastName: lastName,
      facebook: facebookController.text.toString(),
      linkedin: linkedinController.text.toString(),
      skype: skypeController.text.toString(),
      phoneNumber: mobileNoController.text.toString(),
      image: imageFile,
    );

    StatusModel responseModel = await profileRepo.updateProfile(
      profileUpdateModel,
    );

    if (responseModel.status ?? false) {
      Get.back();
      await initialData();
      Get.put(
        DashboardController(dashboardRepo: Get.find()),
      ).initialData(shouldLoad: false);
      CustomSnackBar.success(successList: [responseModel.message!.tr]);
    } else {
      CustomSnackBar.error(errorList: [responseModel.message!.tr]);
    }

    isSubmitLoading = false;
    update();
  }
}
