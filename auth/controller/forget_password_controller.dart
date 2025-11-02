import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutex_admin/features/auth/repo/auth_repo.dart';
import 'package:flutex_admin/common/components/snack_bar/show_custom_snackbar.dart';

class ForgetPasswordController extends GetxController {
  AuthRepo loginRepo;

  ForgetPasswordController({required this.loginRepo});

  bool submitLoading = false;
  TextEditingController emailController = TextEditingController();

  void submitForgetPassword() async {
    String email = emailController.text;

    if (email.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.enterEmail.tr]);
      return;
    }

    submitLoading = true;
    update();
    ResponseModel response = await loginRepo.forgetPassword(email);
    if (response.status) {
      emailController.text = '';
      CustomSnackBar.success(successList: [LocalStrings.logoutSuccessMsg.tr]);
      Get.toNamed(RouteHelper.loginScreen);
    } else {
      CustomSnackBar.error(errorList: [(response.message.tr)]);
    }

    submitLoading = false;
    update();
  }
}
