import 'package:flutex_admin/common/components/buttons/rounded_button.dart';
import 'package:flutex_admin/common/components/buttons/rounded_loading_button.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_text_field.dart';
import 'package:flutex_admin/common/components/text/default_text.dart';
import 'package:flutex_admin/common/components/will_pop_widget.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/features/auth/controller/login_controller.dart';
import 'package:flutex_admin/features/auth/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/images.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient(sharedPreferences: Get.find()));
    }
    if (!Get.isRegistered<AuthRepo>()) {
      Get.put(AuthRepo(apiClient: Get.find()));
    }
    if (!Get.isRegistered<LoginController>()) {
      Get.put(LoginController(loginRepo: Get.find()));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<LoginController>().remember = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);

    // Harmonische Radien & Höhen
    const double corner = 24;
    final double headerH = (size.height * 0.30).clamp(200, 280);
    const double overlap = 28; // Card überlappt Header um 28px

    return WillPopWidget(
      nextRoute: '',
      child: SafeArea(
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: GetBuilder<LoginController>(
            builder: (controller) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // ------- HERO HEADER (nur unten rund, keine Naht)
                    Container(
                      height: headerH,
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(corner),
                          bottomRight: Radius.circular(corner),
                        ),
                        gradient: LinearGradient(
                          colors: [cs.primary, cs.secondary.withOpacity(.9)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        image: const DecorationImage(
                          image: AssetImage(MyImages.login),
                          alignment: Alignment.topRight,
                          fit: BoxFit.cover,
                          opacity: 0.08,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(MyImages.appLogo, height: 56),
                            const SizedBox(height: 8),
                            Text(
                              'LOADUM',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: .4,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              LocalStrings.loginDesc.tr, // „Login to your account“
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ------- FORM CARD (gleiche Radien, perfekte Überlappung)
                    Transform.translate(
                      offset: const Offset(0, -overlap),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(corner),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                LocalStrings.login.tr,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: cs.primary,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Email (onChanged required by your CustomTextField)
                              CustomTextField(
                                labelText: LocalStrings.email.tr,
                                controller: controller.emailController,
                                focusNode: controller.emailFocusNode,
                                nextFocus: controller.passwordFocusNode,
                                textInputType: TextInputType.emailAddress,
                                inputAction: TextInputAction.next,
                                onChanged: (_) {},
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return LocalStrings.fieldErrorMsg.tr;
                                  }
                                  final ok = RegExp(r'^\S+@\S+\.\S+$')
                                      .hasMatch(value.trim());
                                  return ok ? null : 'Please enter a valid email';
                                },
                              ),
                              const SizedBox(height: Dimensions.space20),

                              // Password
                              CustomTextField(
                                labelText: LocalStrings.password.tr,
                                controller: controller.passwordController,
                                focusNode: controller.passwordFocusNode,
                                isShowSuffixIcon: true,
                                isPassword: true,
                                textInputType: TextInputType.text,
                                inputAction: TextInputAction.done,
                                onChanged: (_) {},
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return LocalStrings.fieldErrorMsg.tr;
                                  }
                                  if (value.length < 6) {
                                    return 'Minimum 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),

                              // Remember + Forgot row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: Checkbox(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.defaultRadius),
                                          ),
                                          activeColor: ColorResources.primaryColor,
                                          checkColor: Colors.white,
                                          value: controller.remember,
                                          side: WidgetStateBorderSide.resolveWith(
                                                (states) => BorderSide(
                                              width: 1.0,
                                              color: controller.remember
                                                  ? ColorResources
                                                  .getTextFieldEnableBorder()
                                                  : ColorResources
                                                  .getTextFieldDisableBorder(),
                                            ),
                                          ),
                                          onChanged: (_) =>
                                              controller.changeRememberMe(),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      DefaultText(
                                        text: LocalStrings.rememberMe.tr,
                                        textColor: theme
                                            .textTheme.bodyMedium!.color!
                                            .withValues(alpha: 0.72),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () => Get.toNamed(
                                        RouteHelper.forgotPasswordScreen),
                                    child: Text(
                                      LocalStrings.forgotPassword.tr,
                                      style: theme.textTheme.labelLarge?.copyWith(
                                        color: cs.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: Dimensions.space15),

                              // Submit
                              GetBuilder<LoginController>(
                                id: 'submit',
                                builder: (c) => c.isSubmitLoading
                                    ? const RoundedLoadingBtn()
                                    : RoundedButton(
                                  text: LocalStrings.signIn.tr,
                                  press: () {
                                    if (formKey.currentState!.validate()) {
                                      c.loginUser();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // kleiner Bodenabstand, wirkt luftiger
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
