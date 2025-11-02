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
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/contract/controller/contract_controller.dart';
import 'package:flutex_admin/features/customer/model/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddContractScreen extends StatefulWidget {
  const AddContractScreen({super.key});

  @override
  State<AddContractScreen> createState() => _AddContractScreenState();
}

class _AddContractScreenState extends State<AddContractScreen> {
  final AsyncMemoizer<CustomersModel> customersMemoizer = AsyncMemoizer();

  @override
  void dispose() {
    Get.find<ContractController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.addContract.tr,
      ),
      body: GetBuilder<ContractController>(
        builder: (controller) {
          return RefreshIndicator(
              color: Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).cardColor,
              onRefresh: () async {
                await controller.loadCustomers();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.space15,
                      horizontal: Dimensions.space10),
                  child: Column(
                    spacing: Dimensions.space15,
                    children: [
                      CustomTextField(
                        labelText: LocalStrings.subject.tr,
                        controller: controller.subjectController,
                        focusNode: controller.subjectFocusNode,
                        textInputType: TextInputType.text,
                        nextFocus: controller.clientFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return LocalStrings.enterSubject.tr;
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          return;
                        },
                      ),
                      FutureBuilder(
                          future: customersMemoizer
                              .runOnce(controller.loadCustomers),
                          builder: (context, customerList) {
                            if (customerList.data?.status ?? false) {
                              return CustomDropDownTextField(
                                hintText: LocalStrings.selectClient.tr,
                                onChanged: (value) {
                                  controller.clientController.text = value;
                                },
                                selectedValue: controller.clientController.text,
                                dropDownColor: Theme.of(context).cardColor,
                                items: controller.customersModel.data!
                                    .map((customer) {
                                  return DropdownMenuItem(
                                    value: customer.userId,
                                    child: Text(
                                      customer.company ?? '',
                                      style: regularDefault.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color),
                                    ),
                                  );
                                }).toList(),
                              );
                            } else if (customerList.data?.status == false) {
                              return CustomDropDownWithTextField(
                                  selectedValue: LocalStrings.noClientFound.tr,
                                  list: [LocalStrings.noClientFound.tr]);
                            } else {
                              return const CustomLoader(isFullScreen: false);
                            }
                          }),
                      CustomDateFormField(
                        labelText: LocalStrings.startDate.tr,
                        onChanged: (DateTime? value) {
                          controller.dateStartController.text =
                              DateConverter.formatDate(value!);
                        },
                      ),
                      CustomDateFormField(
                        labelText: LocalStrings.endDate.tr,
                        onChanged: (DateTime? value) {
                          controller.dateEndController.text =
                              DateConverter.formatDate(value!);
                        },
                      ),
                      CustomTextField(
                        labelText: LocalStrings.contractValue.tr,
                        controller: controller.contractValueController,
                        focusNode: controller.contractValueFocusNode,
                        textInputType: TextInputType.number,
                        nextFocus: controller.descriptionFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return LocalStrings.enterValue.tr;
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          return;
                        },
                      ),
                      CustomTextField(
                        labelText: LocalStrings.description.tr,
                        textInputType: TextInputType.multiline,
                        maxLines: 2,
                        focusNode: controller.descriptionFocusNode,
                        controller: controller.descriptionController,
                        nextFocus: controller.contentFocusNode,
                        onChanged: (value) {
                          return;
                        },
                      ),
                      CustomTextField(
                        labelText: LocalStrings.content.tr,
                        textInputType: TextInputType.multiline,
                        maxLines: 5,
                        focusNode: controller.contentFocusNode,
                        controller: controller.contentController,
                        onChanged: (value) {
                          return;
                        },
                      ),
                      const SizedBox(height: Dimensions.space25),
                      controller.isSubmitLoading
                          ? const RoundedLoadingBtn()
                          : RoundedButton(
                              text: LocalStrings.submit.tr,
                              press: () {
                                controller.submitContract();
                              },
                            ),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
