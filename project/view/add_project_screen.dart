import 'package:async/async.dart';
import 'package:flutex_admin/common/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/common/components/buttons/rounded_button.dart';
import 'package:flutex_admin/common/components/buttons/rounded_loading_button.dart';
import 'package:flutex_admin/common/components/custom_date_form_field.dart';
import 'package:flutex_admin/common/components/custom_drop_down_button_with_text_field.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_drop_down_text_field.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_text_field.dart';
import 'package:flutex_admin/core/helper/date_converter.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/customer/model/customer_model.dart';
import 'package:flutex_admin/features/project/controller/project_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final AsyncMemoizer<CustomersModel> customersMemoizer = AsyncMemoizer();

  @override
  void dispose() {
    Get.find<ProjectController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: LocalStrings.addProject.tr),
      body: GetBuilder<ProjectController>(
        builder: (controller) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Dimensions.space15,
                horizontal: Dimensions.space10,
              ),
              child: Column(
                spacing: Dimensions.space15,
                children: [
                  CustomTextField(
                    labelText: LocalStrings.name.tr,
                    controller: controller.nameController,
                    focusNode: controller.nameFocusNode,
                    textInputType: TextInputType.text,
                    nextFocus: controller.clientIdFocusNode,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return LocalStrings.enterFirstName.tr;
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      return;
                    },
                  ),
                  FutureBuilder(
                    future: customersMemoizer.runOnce(controller.loadCustomers),
                    builder: (context, customerList) {
                      if (customerList.data?.status ?? false) {
                        return CustomDropDownTextField(
                          hintText: LocalStrings.selectClient.tr,
                          onChanged: (value) {
                            controller.clientController.text = value;
                          },
                          selectedValue: controller.clientController.text,
                          items: controller.customersModel.data!.map((
                            customer,
                          ) {
                            return DropdownMenuItem(
                              value: customer.userId,
                              child: Text(
                                customer.company ?? '',
                                style: regularDefault.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.color,
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      } else if (customerList.data?.status == false) {
                        return CustomDropDownWithTextField(
                          selectedValue: LocalStrings.noClientFound.tr,
                          list: [LocalStrings.noClientFound.tr],
                        );
                      } else {
                        return const CustomLoader();
                      }
                    },
                  ),
                  CustomDropDownTextField(
                    hintText: LocalStrings.selectBillingType.tr,
                    onChanged: (value) {
                      controller.billingTypeController.text = value;
                      setState(() {});
                    },
                    selectedValue: controller.billingTypeController.text,
                    items: controller.billingType.entries
                        .map(
                          (MapEntry element) => DropdownMenuItem(
                            value: element.key,
                            child: Text(
                              element.value,
                              style: regularDefault.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.color,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  if (controller.billingTypeController.text == '1')
                    CustomTextField(
                      labelText: LocalStrings.totalRate.tr,
                      controller: controller.projectCostController,
                      focusNode: controller.projectCostFocusNode,
                      textInputType: TextInputType.number,
                      nextFocus: controller.statusFocusNode,
                      onChanged: (value) {
                        return;
                      },
                    ),
                  if (controller.billingTypeController.text == '2')
                    CustomTextField(
                      labelText: LocalStrings.ratePerHour.tr,
                      controller: controller.projectRatePerHourController,
                      focusNode: controller.projectRatePerHourFocusNode,
                      textInputType: TextInputType.number,
                      nextFocus: controller.statusFocusNode,
                      onChanged: (value) {
                        return;
                      },
                    ),
                  CustomDropDownTextField(
                    hintText: LocalStrings.selectStatus.tr,
                    onChanged: (value) {
                      controller.statusController.text = value;
                    },
                    selectedValue: controller.statusController.text,
                    items: controller.projectStatus.entries
                        .map(
                          (MapEntry element) => DropdownMenuItem(
                            value: element.key,
                            child: Text(
                              element.value,
                              style: regularDefault.copyWith(
                                color: ColorResources.projectStatusColor(
                                  element.key,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  CustomDateFormField(
                    labelText: LocalStrings.startDate.tr,
                    onChanged: (DateTime? value) {
                      controller.startDateController.text =
                          DateConverter.formatDate(value!);
                    },
                  ),
                  CustomDateFormField(
                    labelText: LocalStrings.endDate.tr,
                    onChanged: (DateTime? value) {
                      controller.deadlineController.text =
                          DateConverter.formatDate(value!);
                    },
                  ),
                  CustomTextField(
                    labelText: LocalStrings.description.tr,
                    textInputType: TextInputType.multiline,
                    maxLines: 3,
                    focusNode: controller.descriptionFocusNode,
                    controller: controller.descriptionController,
                    onChanged: (value) {
                      return;
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(Dimensions.space10),
        child: GetBuilder<ProjectController>(
          builder: (controller) {
            return controller.isLoading
                ? const SizedBox.shrink()
                : controller.submitLoading
                ? const RoundedLoadingBtn()
                : RoundedButton(
                    text: LocalStrings.submit.tr,
                    press: () {
                      controller.submitProject();
                    },
                  );
          },
        ),
      ),
    );
  }
}
