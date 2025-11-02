import 'dart:convert';

import 'package:flutex_admin/common/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/features/privacy/model/privacy_response_model.dart';
import 'package:flutex_admin/features/privacy/repo/privacy_repo.dart';
import 'package:get/get.dart';

class PrivacyController extends GetxController {
  PrivacyRepo privacyRepo;
  PrivacyController({required this.privacyRepo});

  bool isLoading = true;
  PrivacyResponseModel privacyResponseModel = PrivacyResponseModel();

  void loadData() async {
    ResponseModel responseModel = await privacyRepo.loadPrivacyPolicyData();
    if (responseModel.status) {
      privacyResponseModel = PrivacyResponseModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    isLoading = false;
    update();
  }
}
