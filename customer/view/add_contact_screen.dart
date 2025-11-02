import 'package:flutex_admin/common/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/common/components/buttons/rounded_button.dart';
import 'package:flutex_admin/common/components/buttons/rounded_loading_button.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_text_field.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/features/customer/controller/customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key, required this.id});
  final String id;

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();

  // simple email check (nicht ultra streng, aber robust genug)
  bool _isValidEmail(String v) {
    final email = v.trim();
    final regex = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$");
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: LocalStrings.addContact.tr),
      body: GetBuilder<CustomerController>(
        builder: (controller) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.space15,
                  horizontal: Dimensions.space10,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    spacing: Dimensions.space15,
                    children: [
                      // First name
                      CustomTextField(
                        labelText: LocalStrings.firstName.tr,
                        controller: controller.firstNameController,
                        focusNode: controller.firstNameFocusNode,
                        textInputType: TextInputType.name,
                        nextFocus: controller.lastNameFocusNode,
                        validator: (value) {
                          final v = (value ?? '').trim();
                          if (v.isEmpty) return LocalStrings.enterFirstName.tr;
                          return null;
                        },
                        onChanged: (_) {},
                      ),

                      // Last name
                      CustomTextField(
                        labelText: LocalStrings.lastName.tr,
                        controller: controller.lastNameController,
                        focusNode: controller.lastNameFocusNode,
                        textInputType: TextInputType.name,
                        nextFocus: controller.emailFocusNode,
                        validator: (value) {
                          final v = (value ?? '').trim();
                          if (v.isEmpty) return LocalStrings.enterLastName.tr;
                          return null;
                        },
                        onChanged: (_) {},
                      ),

                      // Email
                      CustomTextField(
                        labelText: LocalStrings.email.tr,
                        controller: controller.emailController,
                        focusNode: controller.emailFocusNode,
                        textInputType: TextInputType.emailAddress,
                        nextFocus: controller.titleFocusNode,
                        validator: (value) {
                          final v = (value ?? '').trim();
                          if (v.isEmpty) return LocalStrings.enterEmail.tr;
                          if (!_isValidEmail(v)) return 'Enter a valid email';
                          return null;
                        },
                        onChanged: (_) {},
                      ),

                      // Role/Title (optional)
                      CustomTextField(
                        labelText: LocalStrings.title.tr,
                        controller: controller.titleController,
                        focusNode: controller.titleFocusNode,
                        textInputType: TextInputType.text,
                        nextFocus: controller.phoneFocusNode,
                        // optional → kein Validator
                        onChanged: (_) {},
                      ),

                      // Phone
                      CustomTextField(
                        labelText: LocalStrings.phone.tr,
                        controller: controller.phoneController,
                        focusNode: controller.phoneFocusNode,
                        textInputType: TextInputType.phone,
                        nextFocus: controller.passwordFocusNode,
                        validator: (value) {
                          final v = (value ?? '').trim();
                          if (v.isEmpty) return LocalStrings.enterNumber.tr;
                          if (v.replaceAll(RegExp(r'\D'), '').length < 6) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },
                        onChanged: (_) {},
                      ),

                      // Password (für Portalzugang)
                      CustomTextField(
                        labelText: LocalStrings.password.tr,
                        controller: controller.passwordController,
                        focusNode: controller.passwordFocusNode,
                        textInputType: TextInputType.visiblePassword,
                        isShowSuffixIcon: true,
                        isPassword: true,
                        validator: (value) {
                          final v = (value ?? '').trim();
                          if (v.isEmpty) return LocalStrings.enterYourPassword.tr;
                          if (v.length < 6) return 'Use at least 6 characters';
                          return null;
                        },
                        onChanged: (_) {},
                      ),

                      const SizedBox(height: Dimensions.space25),

                      // Submit
                      controller.isSubmitLoading
                          ? const RoundedLoadingBtn()
                          : RoundedButton(
                        text: LocalStrings.submit.tr,
                        press: () {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState?.validate() ?? false) {
                            controller.submitContact(widget.id);
                          } else {
                            Get.snackbar(
                              'Validation error',
                              LocalStrings.fieldErrorMsg.tr,
                              snackPosition: SnackPosition.BOTTOM,
                              duration: const Duration(seconds: 2),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
