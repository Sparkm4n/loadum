import 'package:async/async.dart';
import 'package:flutex_admin/common/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/common/components/buttons/rounded_button.dart';
import 'package:flutex_admin/common/components/buttons/rounded_loading_button.dart';
import 'package:flutex_admin/common/components/custom_drop_down_button_with_text_field.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_amount_text_field.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_drop_down_text_field.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_text_field.dart';
import 'package:flutex_admin/core/helper/string_format_helper.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/lead/controller/lead_controller.dart';
import 'package:flutex_admin/features/lead/model/sources_model.dart';
import 'package:flutex_admin/features/lead/model/statuses_model.dart';
import 'package:flutex_admin/features/lead/repo/lead_repo.dart';
import 'package:flutex_admin/features/staff/model/staff_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateLeadScreen extends StatefulWidget {
  const UpdateLeadScreen({super.key, required this.id});
  final String id;

  @override
  State<UpdateLeadScreen> createState() => _UpdateTicketScreenState();
}

class _UpdateTicketScreenState extends State<UpdateLeadScreen> {
  final AsyncMemoizer<SourcesModel> sourcesMemoizer = AsyncMemoizer();
  final AsyncMemoizer<StatusesModel> statusesMemoizer = AsyncMemoizer();
  final AsyncMemoizer<StaffsModel> assigneeMemoizer = AsyncMemoizer();
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LeadRepo(apiClient: Get.find()));
    final controller = Get.put(LeadController(leadRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadLeadUpdateData(widget.id);
    });
  }

  @override
  void dispose() {
    Get.find<LeadController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.updateLead.tr,
      ),
      body: GetBuilder<LeadController>(
        builder: (controller) {
          return controller.isLoading
              ? const CustomLoader()
              : RefreshIndicator(
                  color: ColorResources.primaryColor,
                  onRefresh: () async {
                    await controller.loadLeadUpdateData(widget.id);
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
                          FutureBuilder(
                              future: sourcesMemoizer
                                  .runOnce(controller.loadLeadSources),
                              builder: (context, sourceList) {
                                if (sourceList.data?.status ?? false) {
                                  return CustomDropDownTextField(
                                    hintText: LocalStrings.selectSource.tr,
                                    selectedValue:
                                        controller.sourceController.text,
                                    onChanged: (value) {
                                      controller.sourceController.text =
                                          value.toString();
                                    },
                                    items: controller.sourcesModel.data!
                                        .map((Source value) {
                                      return DropdownMenuItem(
                                        value: value.id,
                                        child: Text(
                                          value.name?.tr ?? '',
                                          style: regularDefault.copyWith(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .color),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                } else if (sourceList.data?.status == false) {
                                  return CustomDropDownWithTextField(
                                      selectedValue:
                                          LocalStrings.noSourceFound.tr,
                                      list: [LocalStrings.noSourceFound.tr]);
                                } else {
                                  return const CustomLoader(
                                      isFullScreen: false);
                                }
                              }),
                          FutureBuilder(
                              future: statusesMemoizer
                                  .runOnce(controller.loadLeadStatuses),
                              builder: (context, statusList) {
                                if (statusList.data?.status ?? false) {
                                  return CustomDropDownTextField(
                                    hintText: LocalStrings.selectStatus.tr,
                                    selectedValue:
                                        controller.statusController.text,
                                    onChanged: (value) {
                                      controller.statusController.text =
                                          value.toString();
                                    },
                                    items: controller.statusesModel.data!
                                        .map((Status value) {
                                      return DropdownMenuItem(
                                        value: value.id,
                                        child: Text(
                                          value.name?.tr ?? '',
                                          style: regularDefault.copyWith(
                                              color: Converter.hexStringToColor(
                                                  value.color ?? '')),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                } else if (statusList.data?.status == false) {
                                  return CustomDropDownWithTextField(
                                      selectedValue:
                                          LocalStrings.noStatusFound.tr,
                                      list: [LocalStrings.noStatusFound.tr]);
                                } else {
                                  return const CustomLoader(
                                      isFullScreen: false);
                                }
                              }),
                          FutureBuilder(
                              future: assigneeMemoizer
                                  .runOnce(controller.loadStaff),
                              builder: (context, staffList) {
                                if (staffList.data?.status ?? false) {
                                  return CustomDropDownTextField(
                                    hintText: LocalStrings.selectStaff.tr,
                                    onChanged: (value) {
                                      controller.assignedController.text =
                                          value.toString();
                                    },
                                    selectedValue:
                                        controller.assignedController.text,
                                    items: controller.staffsModel.data!
                                        .map((value) {
                                      return DropdownMenuItem(
                                        value: value.id,
                                        child: Text(
                                          value.fullName ?? '-',
                                          style: regularDefault.copyWith(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .color),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                } else if (staffList.data?.status == false) {
                                  return CustomDropDownWithTextField(
                                      selectedValue:
                                          LocalStrings.noStaffFound.tr,
                                      list: [LocalStrings.noStaffFound.tr]);
                                } else {
                                  return const CustomLoader(
                                      isFullScreen: false);
                                }
                              }),
                          CustomTextField(
                            labelText: LocalStrings.name.tr,
                            controller: controller.nameController,
                            focusNode: controller.nameFocusNode,
                            textInputType: TextInputType.text,
                            nextFocus: controller.valueFocusNode,
                            onChanged: (value) {
                              return;
                            },
                          ),
                          CustomTextField(
                            labelText: LocalStrings.position.tr,
                            controller: controller.titleController,
                            focusNode: controller.titleFocusNode,
                            textInputType: TextInputType.text,
                            nextFocus: controller.emailFocusNode,
                            onChanged: (value) {
                              return;
                            },
                          ),
                          CustomTextField(
                            labelText: LocalStrings.email.tr,
                            controller: controller.emailController,
                            focusNode: controller.emailFocusNode,
                            textInputType: TextInputType.text,
                            nextFocus: controller.websiteFocusNode,
                            onChanged: (value) {
                              return;
                            },
                          ),
                          CustomTextField(
                            labelText: LocalStrings.website.tr,
                            controller: controller.websiteController,
                            focusNode: controller.websiteFocusNode,
                            textInputType: TextInputType.text,
                            nextFocus: controller.phoneNumberFocusNode,
                            onChanged: (value) {
                              return;
                            },
                          ),
                          CustomTextField(
                            labelText: LocalStrings.phone.tr,
                            controller: controller.phoneNumberController,
                            focusNode: controller.phoneNumberFocusNode,
                            textInputType: TextInputType.number,
                            nextFocus: controller.companyFocusNode,
                            onChanged: (value) {
                              return;
                            },
                          ),
                          CustomTextField(
                            labelText: LocalStrings.company.tr,
                            controller: controller.companyController,
                            focusNode: controller.companyFocusNode,
                            textInputType: TextInputType.text,
                            nextFocus: controller.addressFocusNode,
                            onChanged: (value) {
                              return;
                            },
                          ),
                          CustomTextField(
                            labelText: LocalStrings.address.tr,
                            controller: controller.addressController,
                            focusNode: controller.addressFocusNode,
                            textInputType: TextInputType.text,
                            onChanged: (value) {
                              return;
                            },
                          ),
                          CustomAmountTextField(
                            controller: controller.valueController,
                            hintText: LocalStrings.leadValue.tr,
                            currency: '\$',
                            onChanged: (value) {
                              return;
                            },
                          ),
                          const SizedBox(height: Dimensions.space5),
                          controller.isLoading
                              ? const SizedBox.shrink()
                              : controller.isSubmitLoading
                                  ? const RoundedLoadingBtn()
                                  : RoundedButton(
                                      text: LocalStrings.update.tr,
                                      press: () {
                                        controller.submitLead(
                                            leadId: widget.id, isUpdate: true);
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
