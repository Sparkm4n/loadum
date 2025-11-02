// lib/features/auth/controller/login_controller.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:flutex_admin/common/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutex_admin/common/models/response_model.dart';
import 'package:flutex_admin/core/helper/shared_preference_helper.dart';
import 'package:flutex_admin/core/route/route.dart';

import 'package:flutex_admin/features/auth/model/login_model.dart';
import 'package:flutex_admin/features/auth/repo/auth_repo.dart';

class LoginController extends GetxController {
  final AuthRepo loginRepo;

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool remember = false;
  bool isSubmitLoading = false;

  LoginController({required this.loginRepo});

  Future<void> loginUser() async {
    isSubmitLoading = true;
    update();

    final ResponseModel resp = await loginRepo.loginUser(
      emailController.text.trim(),
      passwordController.text,
    );

    if (resp.status) {
      Map<String, dynamic> root;
      try {
        root = jsonDecode(resp.responseJson) as Map<String, dynamic>;
      } catch (_) {
        root = {};
      }

      final loginModel = LoginModel.fromJson(root);
      await _afterSuccessfulLogin(loginModel, root);
    } else {
      CustomSnackBar.error(errorList: [resp.message.tr]);
    }

    isSubmitLoading = false;
    update();
  }

  void changeRememberMe() {
    remember = !remember;
    update();
  }

  void clearTextField() {
    emailController.clear();
    passwordController.clear();
    if (remember) remember = false;
    update();
  }

  Future<void> _afterSuccessfulLogin(
      LoginModel model,
      Map<String, dynamic> rootJson,
      ) async {
    await loginRepo.apiClient.sharedPreferences.setBool(
      SharedPreferenceHelper.rememberMeKey,
      remember,
    );

    final userId = model.data?.staffId?.toString() ??
        (rootJson['data']?['staff_id']?.toString()) ??
        (rootJson['staff']?['id']?.toString()) ??
        '-1';
    await loginRepo.apiClient.sharedPreferences
        .setString(SharedPreferenceHelper.userIdKey, userId);

    // Token aus allen sinnvollen Feldern lesen
    final token = _extractAnyToken(model, rootJson);

    if (token != null && token.isNotEmpty) {
      await loginRepo.apiClient.saveToken(token);
      // FCM nur probieren, wenn wirklich ein API-Token verfügbar
      if (loginRepo.apiClient.bareToken.isNotEmpty) {
        try {
          await loginRepo.updateToken();
        } catch (_) {}
      }
    } else {
      CustomSnackBar.error(errorList: ['Login ok, aber kein Token erhalten.']);
    }

    Get.offAndToNamed(RouteHelper.dashboardScreen);

    if (remember) changeRememberMe();
  }

  String? _extractAnyToken(LoginModel model, Map<String, dynamic> root) {
    final candidates = <dynamic>[
      model.data?.accessToken,
      root['access_token'],
      root['token'],
      root['api_token'],
      root['data']?['access_token'],
      root['data']?['token'],
      root['data']?['api_token'],
      root['staff']?['access_token'],
      root['staff']?['token'],
      root['staff']?['api_token'],
      root['data']?['staff']?['access_token'],
      root['data']?['staff']?['token'],
      root['data']?['staff']?['api_token'],
    ];
    for (final v in candidates) {
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
    return null;
  }

  @override
  void onClose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
