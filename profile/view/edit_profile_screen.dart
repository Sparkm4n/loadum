import 'package:flutex_admin/common/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/common/components/buttons/rounded_button.dart';
import 'package:flutex_admin/common/components/buttons/rounded_loading_button.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_text_field.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/features/profile/controller/profile_controller.dart';
import 'package:flutex_admin/features/profile/repo/profile_repo.dart';
import 'package:flutex_admin/features/profile/widget/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ProfileRepo(apiClient: Get.find()));
    final controller = Get.put(ProfileController(profileRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadProfileEditInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) => Scaffold(
        appBar: CustomAppBar(title: LocalStrings.editProfile.tr),
        body: Stack(
          children: [
            Positioned(
              top: -10,
              child: Container(
                height: 120,
                width: MediaQuery.of(context).size.width,
                color: ColorResources.primaryColor,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.space15,
                  vertical: Dimensions.space20,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.space15,
                    horizontal: Dimensions.space30,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ProfileWidget(
                          isEdit: true,
                          imagePath: controller.imageUrl,
                          onClicked: () async {},
                        ),
                        const SizedBox(height: Dimensions.space20),
                        CustomTextField(
                          labelText: LocalStrings.firstName.tr,
                          validator: (value) {
                            if ((value == null || value.isEmpty)) {
                              return '${LocalStrings.firstName.tr} ${LocalStrings.isRequired.tr}';
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                          focusNode: controller.firstNameFocusNode,
                          controller: controller.firstNameController,
                        ),
                        const SizedBox(height: Dimensions.space15),
                        CustomTextField(
                          labelText: LocalStrings.lastName.tr,
                          onChanged: (value) {},
                          validator: (value) {
                            if ((value == null || value.isEmpty)) {
                              return '${LocalStrings.lastName.tr} ${LocalStrings.isRequired.tr}';
                            } else {
                              return null;
                            }
                          },
                          focusNode: controller.lastNameFocusNode,
                          controller: controller.lastNameController,
                        ),
                        const SizedBox(height: Dimensions.space15),
                        CustomTextField(
                          labelText: LocalStrings.email.tr,
                          readOnly: true,
                          isEnable: false,
                          fillColor: Theme.of(
                            context,
                          ).disabledColor.withValues(alpha: 0.1),
                          onChanged: (value) {},
                          focusNode: controller.emailFocusNode,
                          controller: controller.emailController,
                        ),
                        const SizedBox(height: Dimensions.space15),
                        CustomTextField(
                          labelText: LocalStrings.phone.tr,
                          readOnly: true,
                          isEnable: false,
                          fillColor: Theme.of(
                            context,
                          ).disabledColor.withValues(alpha: 0.1),
                          onChanged: (value) {},
                          focusNode: controller.mobileNoFocusNode,
                          controller: controller.mobileNoController,
                        ),
                        const SizedBox(height: Dimensions.space30),
                        controller.isSubmitLoading
                            ? const RoundedLoadingBtn()
                            : RoundedButton(
                                text: LocalStrings.updateProfile.tr,
                                press: () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    controller.updateProfile();
                                  }
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
