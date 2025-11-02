import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutex_admin/common/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/common/components/buttons/rounded_button.dart';
import 'package:flutex_admin/common/components/buttons/rounded_loading_button.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_text_field.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/staff/controller/staff_controller.dart';
import 'package:flutex_admin/features/staff/widget/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddStaffScreen extends StatefulWidget {
  const AddStaffScreen({super.key});

  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    Get.find<StaffController>().clearStaffData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: LocalStrings.addStaff.tr),
      body: GetBuilder<StaffController>(
        builder: (controller) {
          return ContainedTabBarView(
            tabBarProperties: TabBarProperties(
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor: ColorResources.blueGreyColor,
              labelColor: Theme.of(context).textTheme.bodyLarge!.color,
              labelStyle: regularDefault,
              indicatorColor: ColorResources.secondaryColor,
              labelPadding: const EdgeInsets.symmetric(
                vertical: Dimensions.space15,
              ),
            ),
            tabs: [
              Text(LocalStrings.profile.tr),
              Text(LocalStrings.permissons.tr),
            ],
            views: [
              Padding(
                padding: const EdgeInsets.all(Dimensions.space10),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      spacing: Dimensions.space15,
                      children: [
                        ProfileWidget(
                          isEdit: true,
                          imagePath: controller.imageUrl,
                          onClicked: () async {},
                        ),
                        Column(
                          children: [
                            CheckboxListTile(
                              title: Text(
                                LocalStrings.administrator.tr,
                                style: regularDefault,
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  Dimensions.defaultRadius,
                                ),
                              ),
                              activeColor: ColorResources.primaryColor,
                              checkColor: ColorResources.colorWhite,
                              value: controller.isAdministrator,
                              side: WidgetStateBorderSide.resolveWith(
                                (states) => BorderSide(
                                  width: 1.0,
                                  color: controller.isAdministrator
                                      ? ColorResources.getTextFieldEnableBorder()
                                      : ColorResources.getTextFieldDisableBorder(),
                                ),
                              ),
                              onChanged: (value) {
                                controller.changeIsAdministrator();
                              },
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                            ),
                            Visibility(
                              visible: !controller.isAdministrator,
                              child: CheckboxListTile(
                                title: Text(
                                  LocalStrings.notStaffMember.tr,
                                  style: regularDefault,
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.defaultRadius,
                                  ),
                                ),
                                activeColor: ColorResources.primaryColor,
                                checkColor: ColorResources.colorWhite,
                                value: controller.notStaffMember,
                                side: WidgetStateBorderSide.resolveWith(
                                  (states) => BorderSide(
                                    width: 1.0,
                                    color: controller.notStaffMember
                                        ? ColorResources.getTextFieldEnableBorder()
                                        : ColorResources.getTextFieldDisableBorder(),
                                  ),
                                ),
                                onChanged: (value) {
                                  controller.changeNotStaffMember();
                                },
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                              ),
                            ),
                          ],
                        ),
                        CustomTextField(
                          labelText: LocalStrings.firstName.tr,
                          controller: controller.firstNameController,
                          focusNode: controller.firstNameFocusNode,
                          textInputType: TextInputType.text,
                          nextFocus: controller.lastNameFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '${LocalStrings.firstName.tr} ${LocalStrings.isRequired.tr}';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            return;
                          },
                        ),
                        CustomTextField(
                          labelText: LocalStrings.lastName.tr,
                          controller: controller.lastNameController,
                          focusNode: controller.lastNameFocusNode,
                          textInputType: TextInputType.text,
                          nextFocus: controller.emailFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '${LocalStrings.lastName.tr} ${LocalStrings.isRequired.tr}';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            return;
                          },
                        ),
                        CustomTextField(
                          labelText: LocalStrings.email.tr,
                          controller: controller.emailController,
                          focusNode: controller.emailFocusNode,
                          textInputType: TextInputType.text,
                          nextFocus: controller.phoneNumberFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '${LocalStrings.email.tr} ${LocalStrings.isRequired.tr}';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            return;
                          },
                        ),
                        CustomTextField(
                          labelText: LocalStrings.phone.tr,
                          controller: controller.phoneNumberController,
                          focusNode: controller.phoneNumberFocusNode,
                          textInputType: TextInputType.number,
                          nextFocus: controller.hourlyRateFocusNode,
                          onChanged: (value) {
                            return;
                          },
                        ),
                        CustomTextField(
                          labelText: LocalStrings.hourlyRate.tr,
                          controller: controller.hourlyRateController,
                          focusNode: controller.hourlyRateFocusNode,
                          nextFocus: controller.facebookFocusNode,
                          textInputType: TextInputType.number,
                          onChanged: (value) {
                            return;
                          },
                        ),
                        CustomTextField(
                          labelText: LocalStrings.facebook.tr,
                          controller: controller.facebookController,
                          focusNode: controller.facebookFocusNode,
                          nextFocus: controller.linkedInFocusNode,
                          textInputType: TextInputType.text,
                          onChanged: (value) {
                            return;
                          },
                        ),
                        CustomTextField(
                          labelText: LocalStrings.linkedIn.tr,
                          controller: controller.linkedInController,
                          focusNode: controller.linkedInFocusNode,
                          nextFocus: controller.skypeFocusNode,
                          textInputType: TextInputType.text,
                          onChanged: (value) {
                            return;
                          },
                        ),
                        CustomTextField(
                          labelText: LocalStrings.skype.tr,
                          controller: controller.skypeController,
                          focusNode: controller.skypeFocusNode,
                          nextFocus: controller.passwordFocusNode,
                          textInputType: TextInputType.text,
                          onChanged: (value) {
                            return;
                          },
                        ),
                        CustomTextField(
                          labelText: LocalStrings.password.tr,
                          controller: controller.passwordController,
                          focusNode: controller.passwordFocusNode,
                          onChanged: (value) {},
                          isShowSuffixIcon: true,
                          isPassword: true,
                          textInputType: TextInputType.text,
                          inputAction: TextInputAction.done,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '${LocalStrings.password.tr} ${LocalStrings.isRequired.tr}';
                            }
                            return null;
                          },
                        ),
                        CheckboxListTile(
                          title: Text(
                            LocalStrings.sendWelcomeEmail.tr,
                            style: regularDefault,
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              Dimensions.defaultRadius,
                            ),
                          ),
                          activeColor: ColorResources.primaryColor,
                          checkColor: ColorResources.colorWhite,
                          value: controller.sendWelcomeEmail,
                          side: WidgetStateBorderSide.resolveWith(
                            (states) => BorderSide(
                              width: 1.0,
                              color: controller.sendWelcomeEmail
                                  ? ColorResources.getTextFieldEnableBorder()
                                  : ColorResources.getTextFieldDisableBorder(),
                            ),
                          ),
                          onChanged: (value) {
                            controller.changeSendWelcomeEmail();
                          },
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Dimensions.space10),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    spacing: Dimensions.space15,
                    children: [
                      /*FutureBuilder(
                        future: Future.delayed(const Duration(seconds: 3)),
                        builder: (context, data) {
                          return CustomDropDownTextField(
                            hintText: LocalStrings.selectShippingCountry.tr,
                            onChanged: (value) {
                              controller.shippingCountryController.text = value
                                  .toString();
                            },
                            selectedValue:
                                controller.shippingCountryController.text,
                            items: controller.countriesModel.data!.map((value) {
                              return DropdownMenuItem(
                                value: value.countryId,
                                child: Text(
                                  value.shortName?.tr ?? '',
                                  style: regularDefault.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.color,
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),*/
                      ExpansionPanelList.radio(
                        elevation: 1,
                        expandedHeaderPadding: EdgeInsets.zero,
                        children: [
                          customExpansionPanelRadio(
                            LocalStrings.bulkPDFExport.tr,
                            [
                              customCheckboxListTile(
                                LocalStrings.viewGlobal.tr,
                                false,
                              ),
                            ],
                          ),
                          customExpansionPanelRadio(LocalStrings.contracts.tr, [
                            customCheckboxListTile(
                              LocalStrings.viewOwn.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.viewGlobal.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.create.tr,
                              true,
                            ),
                            customCheckboxListTile(LocalStrings.edit.tr, true),
                            customCheckboxListTile(
                              LocalStrings.delete.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.viewAllTemplates.tr,
                              true,
                            ),
                          ]),
                          customExpansionPanelRadio(
                            LocalStrings.creditNotes.tr,
                            [
                              customCheckboxListTile(
                                LocalStrings.viewOwn.tr,
                                true,
                              ),
                              customCheckboxListTile(
                                LocalStrings.viewGlobal.tr,
                                true,
                              ),
                              customCheckboxListTile(
                                LocalStrings.create.tr,
                                true,
                              ),
                              customCheckboxListTile(
                                LocalStrings.edit.tr,
                                true,
                              ),
                              customCheckboxListTile(
                                LocalStrings.delete.tr,
                                true,
                              ),
                            ],
                          ),
                          customExpansionPanelRadio(LocalStrings.customers.tr, [
                            customCheckboxListTile(
                              LocalStrings.viewOwn.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.viewGlobal.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.create.tr,
                              true,
                            ),
                            customCheckboxListTile(LocalStrings.edit.tr, true),
                            customCheckboxListTile(
                              LocalStrings.delete.tr,
                              true,
                            ),
                          ]),
                          customExpansionPanelRadio(
                            LocalStrings.emailTemplates.tr,
                            [
                              customCheckboxListTile(
                                LocalStrings.viewGlobal.tr,
                                true,
                              ),
                              customCheckboxListTile(
                                LocalStrings.edit.tr,
                                true,
                              ),
                            ],
                          ),
                          customExpansionPanelRadio(LocalStrings.estimates.tr, [
                            customCheckboxListTile(
                              LocalStrings.viewOwn.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.viewGlobal.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.create.tr,
                              true,
                            ),
                            customCheckboxListTile(LocalStrings.edit.tr, true),
                            customCheckboxListTile(
                              LocalStrings.delete.tr,
                              true,
                            ),
                          ]),
                          customExpansionPanelRadio(LocalStrings.expenses.tr, [
                            customCheckboxListTile(
                              LocalStrings.viewOwn.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.viewGlobal.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.create.tr,
                              true,
                            ),
                            customCheckboxListTile(LocalStrings.edit.tr, true),
                            customCheckboxListTile(
                              LocalStrings.delete.tr,
                              true,
                            ),
                          ]),
                          customExpansionPanelRadio(LocalStrings.invoices.tr, [
                            customCheckboxListTile(
                              LocalStrings.viewOwn.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.viewGlobal.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.create.tr,
                              true,
                            ),
                            customCheckboxListTile(LocalStrings.edit.tr, true),
                            customCheckboxListTile(
                              LocalStrings.delete.tr,
                              true,
                            ),
                          ]),
                          customExpansionPanelRadio(LocalStrings.items.tr, [
                            customCheckboxListTile(
                              LocalStrings.viewGlobal.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.create.tr,
                              true,
                            ),
                            customCheckboxListTile(LocalStrings.edit.tr, true),
                            customCheckboxListTile(
                              LocalStrings.delete.tr,
                              true,
                            ),
                          ]),
                          customExpansionPanelRadio(
                            LocalStrings.knowledgeBase.tr,
                            [
                              customCheckboxListTile(
                                LocalStrings.viewGlobal.tr,
                                true,
                              ),
                              customCheckboxListTile(
                                LocalStrings.create.tr,
                                true,
                              ),
                              customCheckboxListTile(
                                LocalStrings.edit.tr,
                                true,
                              ),
                              customCheckboxListTile(
                                LocalStrings.delete.tr,
                                true,
                              ),
                            ],
                          ),
                          customExpansionPanelRadio(LocalStrings.payments.tr, [
                            customCheckboxListTile(
                              LocalStrings.viewOwn.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.viewGlobal.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.create.tr,
                              true,
                            ),
                            customCheckboxListTile(LocalStrings.edit.tr, true),
                            customCheckboxListTile(
                              LocalStrings.delete.tr,
                              true,
                            ),
                          ]),
                          customExpansionPanelRadio(LocalStrings.projects.tr, [
                            customCheckboxListTile(
                              LocalStrings.viewOwn.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.viewGlobal.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.create.tr,
                              true,
                            ),
                            customCheckboxListTile(LocalStrings.edit.tr, true),
                            customCheckboxListTile(
                              LocalStrings.delete.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.createTimesheets.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.editMilestones.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.deleteMilestones.tr,
                              true,
                            ),
                          ]),
                          customExpansionPanelRadio(LocalStrings.proposals.tr, [
                            customCheckboxListTile(
                              LocalStrings.viewOwn.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.viewGlobal.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.create.tr,
                              true,
                            ),
                            customCheckboxListTile(LocalStrings.edit.tr, true),
                            customCheckboxListTile(
                              LocalStrings.delete.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.viewAllTemplates.tr,
                              true,
                            ),
                          ]),
                          customExpansionPanelRadio(LocalStrings.reports.tr, [
                            customCheckboxListTile(
                              LocalStrings.viewGlobal.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.viewTimesheetsReport.tr,
                              true,
                            ),
                          ]),
                          customExpansionPanelRadio(
                            LocalStrings.staffRoles.tr,
                            [
                              customCheckboxListTile(
                                LocalStrings.viewGlobal.tr,
                                true,
                              ),
                              customCheckboxListTile(
                                LocalStrings.create.tr,
                                true,
                              ),
                              customCheckboxListTile(
                                LocalStrings.edit.tr,
                                true,
                              ),
                              customCheckboxListTile(
                                LocalStrings.delete.tr,
                                true,
                              ),
                            ],
                          ),
                          customExpansionPanelRadio(LocalStrings.settings.tr, [
                            customCheckboxListTile(
                              LocalStrings.viewGlobal.tr,
                              true,
                            ),
                            customCheckboxListTile(LocalStrings.edit.tr, true),
                          ]),
                          customExpansionPanelRadio(LocalStrings.staff.tr, [
                            customCheckboxListTile(
                              LocalStrings.viewGlobal.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.create.tr,
                              true,
                            ),
                            customCheckboxListTile(LocalStrings.edit.tr, true),
                            customCheckboxListTile(
                              LocalStrings.delete.tr,
                              true,
                            ),
                          ]),
                          customExpansionPanelRadio(
                            LocalStrings.subscriptions.tr,
                            [
                              customCheckboxListTile(
                                LocalStrings.viewOwn.tr,
                                true,
                              ),
                              customCheckboxListTile(
                                LocalStrings.viewGlobal.tr,
                                true,
                              ),
                              customCheckboxListTile(
                                LocalStrings.create.tr,
                                true,
                              ),
                              customCheckboxListTile(
                                LocalStrings.edit.tr,
                                true,
                              ),
                              customCheckboxListTile(
                                LocalStrings.delete.tr,
                                true,
                              ),
                            ],
                          ),
                          customExpansionPanelRadio(LocalStrings.tasks.tr, [
                            customCheckboxListTile(
                              LocalStrings.viewOwn.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.viewGlobal.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.create.tr,
                              true,
                            ),
                            customCheckboxListTile(LocalStrings.edit.tr, true),
                            customCheckboxListTile(
                              LocalStrings.delete.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.editTimesheetsGlobal.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.editOwnTimesheets.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.deleteTimesheetsGlobal.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.deleteOwnTimesheets.tr,
                              true,
                            ),
                          ]),
                          customExpansionPanelRadio(
                            LocalStrings.taskChecklistTemplates.tr,
                            [
                              customCheckboxListTile(
                                LocalStrings.create.tr,
                                true,
                              ),
                              customCheckboxListTile(
                                LocalStrings.delete.tr,
                                true,
                              ),
                            ],
                          ),
                          customExpansionPanelRadio(
                            LocalStrings.estimateRequest.tr,
                            [
                              customCheckboxListTile(
                                LocalStrings.viewOwn.tr,
                                true,
                              ),
                              customCheckboxListTile(
                                LocalStrings.viewGlobal.tr,
                                true,
                              ),
                              customCheckboxListTile(
                                LocalStrings.create.tr,
                                true,
                              ),
                              customCheckboxListTile(
                                LocalStrings.edit.tr,
                                true,
                              ),
                              customCheckboxListTile(
                                LocalStrings.delete.tr,
                                true,
                              ),
                            ],
                          ),
                          customExpansionPanelRadio(LocalStrings.leads.tr, [
                            customCheckboxListTile(
                              LocalStrings.viewGlobal.tr,
                              true,
                            ),
                            customCheckboxListTile(
                              LocalStrings.delete.tr,
                              true,
                            ),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(Dimensions.space10),
        child: GetBuilder<StaffController>(
          builder: (controller) {
            return controller.isSubmitLoading
                ? const RoundedLoadingBtn()
                : RoundedButton(
                    text: LocalStrings.submit.tr,
                    press: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        controller.submitStaff();
                      }
                    },
                  );
          },
        ),
      ),
    );
  }
}

ExpansionPanelRadio customExpansionPanelRadio(
  String title,
  List<Widget> children,
) {
  return ExpansionPanelRadio(
    value: title,
    headerBuilder: (context, isExpanded) {
      return ListTile(
        title: Text(
          title,
          style: regularDefault.copyWith(
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
      );
    },
    body: Column(children: children),
  );
}

Widget customCheckboxListTile(String title, bool value) {
  return CheckboxListTile(
    title: Text(title, style: regularDefault),
    controlAffinity: ListTileControlAffinity.leading,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
    ),
    activeColor: ColorResources.primaryColor,
    checkColor: ColorResources.colorWhite,
    value: value,
    side: WidgetStateBorderSide.resolveWith(
      (states) => BorderSide(
        width: 1.0,
        color: value
            ? ColorResources.getTextFieldEnableBorder()
            : ColorResources.getTextFieldDisableBorder(),
      ),
    ),
    onChanged: (value) {
      //controller.changeSendWelcomeEmail();
    },
    contentPadding: EdgeInsets.zero,
    dense: true,
  );
}
