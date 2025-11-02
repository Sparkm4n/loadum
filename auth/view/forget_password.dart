import 'package:flutex_admin/common/components/buttons/rounded_button.dart';
import 'package:flutex_admin/common/components/buttons/rounded_loading_button.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_text_field.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/images.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/features/auth/controller/forget_password_controller.dart';
import 'package:flutex_admin/features/auth/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient(sharedPreferences: Get.find()));
    }
    if (!Get.isRegistered<AuthRepo>()) {
      Get.put(AuthRepo(apiClient: Get.find()));
    }
    if (!Get.isRegistered<ForgetPasswordController>()) {
      Get.put(ForgetPasswordController(loginRepo: Get.find()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);

    const double corner = 24;
    final double headerH = (size.height * 0.28).clamp(200, 260);

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            // FIX: expliziter Call statt Tear-off
            onPressed: () => Get.back(),
            // FIX: kein fehlender LocalStrings-Key
            tooltip: 'Back',
          ),
        ),
        body: GetBuilder<ForgetPasswordController>(
          builder: (auth) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Header
                  Container(
                    height: headerH,
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 8),
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
                            LocalStrings.forgotPasswordTitle.tr,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            LocalStrings.forgotPasswordDesc.tr,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(.9),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Form-Card
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 22, 16, 20),
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
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              LocalStrings.emailAddress.tr,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: cs.primary,
                              ),
                            ),
                            const SizedBox(height: 8),

                            CustomTextField(
                              labelText: LocalStrings.emailAddress.tr,
                              hintText: LocalStrings.emailAddressHint.tr,
                              controller: auth.emailController,
                              textInputType: TextInputType.emailAddress,
                              inputAction: TextInputAction.done,
                              onSuffixTap: () {},
                              // FIX: required callback vorhanden
                              onChanged: (v) {},
                              validator: (value) {
                                final text = value?.trim() ?? '';
                                if (text.isEmpty) {
                                  return LocalStrings.enterEmail.tr;
                                }
                                final ok =
                                RegExp(r'^\S+@\S+\.\S+$').hasMatch(text);
                                if (!ok) return 'Please enter a valid email';
                                return null;
                              },
                            ),

                            const SizedBox(height: Dimensions.space20),

                            Text(
                              'We’ll email you a secure link to reset your password.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodyMedium!.color!
                                    .withOpacity(.75),
                              ),
                            ),

                            const SizedBox(height: Dimensions.space25),

                            auth.submitLoading
                                ? const RoundedLoadingBtn()
                                : RoundedButton(
                              text: LocalStrings.submit.tr,
                              press: () {
                                if (_formKey.currentState!.validate()) {
                                  auth.submitForgetPassword();
                                }
                              },
                            ),

                            const SizedBox(height: Dimensions.space10),

                            // FIX: kein LocalStrings.backToLogin verwendet
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () => Get.back(),
                                child: Text(
                                  'Back to login',
                                  style:
                                  theme.textTheme.labelLarge?.copyWith(
                                    color: cs.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
