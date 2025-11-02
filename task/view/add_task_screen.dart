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
import 'package:flutex_admin/features/contract/model/contract_model.dart';
import 'package:flutex_admin/features/customer/model/customer_model.dart';
import 'package:flutex_admin/features/estimate/model/estimate_model.dart';
import 'package:flutex_admin/features/invoice/model/invoice_model.dart';
import 'package:flutex_admin/features/lead/model/lead_model.dart';
import 'package:flutex_admin/features/project/model/project_model.dart';
import 'package:flutex_admin/features/proposal/model/proposal_model.dart';
import 'package:flutex_admin/features/task/controller/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final AsyncMemoizer<CustomersModel> customersMemoizer = AsyncMemoizer();
  final AsyncMemoizer<LeadsModel> leadsMemoizer = AsyncMemoizer();
  final AsyncMemoizer<ProjectsModel> projectsMemoizer = AsyncMemoizer();
  final AsyncMemoizer<InvoicesModel> invoicesMemoizer = AsyncMemoizer();
  final AsyncMemoizer<ProposalsModel> proposalsMemoizer = AsyncMemoizer();
  final AsyncMemoizer<ContractsModel> contractsMemoizer = AsyncMemoizer();
  final AsyncMemoizer<EstimatesModel> estimatesMemoizer = AsyncMemoizer();

  @override
  void dispose() {
    Get.find<TaskController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.createNewTask.tr,
      ),
      body: GetBuilder<TaskController>(
        builder: (controller) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.space15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                            title: Text(
                              LocalStrings.public.tr,
                              style: regularDefault.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.defaultRadius)),
                            activeColor: ColorResources.primaryColor,
                            checkColor: ColorResources.colorWhite,
                            value: controller.isPublic,
                            side: WidgetStateBorderSide.resolveWith(
                              (states) => BorderSide(
                                  width: 1.0,
                                  color: controller.isPublic
                                      ? ColorResources
                                          .getTextFieldEnableBorder()
                                      : ColorResources
                                          .getTextFieldDisableBorder()),
                            ),
                            onChanged: (value) {
                              controller.changeIsPublic();
                            }),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                            title: Text(
                              LocalStrings.billable.tr,
                              style: regularDefault.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.defaultRadius)),
                            activeColor: ColorResources.primaryColor,
                            checkColor: ColorResources.colorWhite,
                            value: controller.billable,
                            side: WidgetStateBorderSide.resolveWith(
                              (states) => BorderSide(
                                  width: 1.0,
                                  color: controller.billable
                                      ? ColorResources
                                          .getTextFieldEnableBorder()
                                      : ColorResources
                                          .getTextFieldDisableBorder()),
                            ),
                            onChanged: (value) {
                              controller.changeBillable();
                            }),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.space5),
                  CustomTextField(
                    labelText: LocalStrings.subject.tr,
                    controller: controller.subjectController,
                    focusNode: controller.subjectFocusNode,
                    textInputType: TextInputType.text,
                    nextFocus: controller.rateFocusNode,
                    onChanged: (value) {
                      return;
                    },
                  ),
                  const SizedBox(height: Dimensions.space15),
                  Visibility(
                    visible: controller.taskRelatedController.text != 'project',
                    child: CustomTextField(
                      labelText: LocalStrings.hourlyRate.tr,
                      controller: controller.rateController,
                      focusNode: controller.rateFocusNode,
                      textInputType: TextInputType.text,
                      onChanged: (value) {
                        return;
                      },
                    ),
                  ),
                  Visibility(
                    visible: controller.taskRelatedController.text == 'project',
                    child: CustomTextField(
                      labelText: LocalStrings.milestone.tr,
                      controller: controller.rateController,
                      focusNode: controller.rateFocusNode,
                      textInputType: TextInputType.text,
                      onChanged: (value) {
                        return;
                      },
                    ),
                  ),
                  const SizedBox(height: Dimensions.space15),
                  Row(
                    children: [
                      Expanded(
                        child: CustomDateFormField(
                          labelText: LocalStrings.startDate.tr,
                          onChanged: (DateTime? value) {
                            controller.startDateController.text =
                                DateConverter.formatDate(value!);
                          },
                        ),
                      ),
                      const SizedBox(width: Dimensions.space5),
                      Expanded(
                        child: CustomDateFormField(
                          labelText: LocalStrings.dueDate.tr,
                          onChanged: (DateTime? value) {
                            controller.dueDateController.text =
                                DateConverter.formatDate(value!);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.space15),
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropDownTextField(
                          hintText: LocalStrings.selectPriority.tr,
                          onChanged: (value) {
                            controller.taskPriorityController.text = value;
                          },
                          selectedValue: controller.taskPriorityController.text,
                          items: controller.taskPriority.entries
                              .map((MapEntry element) => DropdownMenuItem(
                                    value: element.key,
                                    child: Text(
                                      element.value,
                                      style: regularDefault.copyWith(
                                        color: ColorResources.taskPriorityColor(
                                            element.key ?? ''),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(width: Dimensions.space5),
                      Expanded(
                        child: CustomDropDownTextField(
                          hintText: LocalStrings.repeatEvery.tr,
                          onChanged: (value) {
                            controller.repeatEveryController.text = value;
                            controller.update();
                          },
                          dropDownColor: Theme.of(context).cardColor,
                          items: controller.repeatEvery.entries
                              .map((MapEntry element) => DropdownMenuItem(
                                    value: element.key,
                                    child: Text(
                                      element.value,
                                      style: regularDefault.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.space15),
                  Visibility(
                    visible: controller.repeatEveryController.text == '8',
                    child: Padding(
                      padding:
                          const EdgeInsets.only(bottom: Dimensions.space15),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              animatedLabel: true,
                              needOutlineBorder: true,
                              labelText: LocalStrings.recurring.tr,
                              controller:
                                  controller.repeatEveryCustomController,
                              focusNode: controller.repeatEveryCustomFocusNode,
                              textInputType: TextInputType.number,
                              nextFocus: controller.repeatTypeCustomFocusNode,
                              onChanged: (value) {
                                return;
                              },
                            ),
                          ),
                          const SizedBox(width: Dimensions.space5),
                          Expanded(
                            child: CustomDropDownTextField(
                              hintText: LocalStrings.repeatType.tr,
                              onChanged: (value) {
                                controller.repeatTypeCustomController.text =
                                    value;
                              },
                              dropDownColor: Theme.of(context).cardColor,
                              items: controller.repeatType.entries
                                  .map((MapEntry element) => DropdownMenuItem(
                                        value: element.key,
                                        child: Text(
                                          element.value,
                                          style: regularDefault.copyWith(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .color),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomDropDownTextField(
                    hintText: LocalStrings.relatedTo.tr,
                    onChanged: (value) {
                      controller.taskRelatedController.text = value;
                      controller.update();
                    },
                    dropDownColor: Theme.of(context).cardColor,
                    items: controller.taskRelated.entries
                        .map((MapEntry element) => DropdownMenuItem(
                              value: element.key,
                              child: Text(
                                element.value,
                                style: regularDefault.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color),
                              ),
                            ))
                        .toList(),
                  ),
                  if (controller.taskRelatedController.text == 'customer')
                    Padding(
                      padding: const EdgeInsets.only(top: Dimensions.space15),
                      child: FutureBuilder(
                          future: customersMemoizer
                              .runOnce(controller.loadCustomers),
                          builder: (context, customerList) {
                            if (customerList.data?.status ?? false) {
                              return CustomDropDownTextField(
                                hintText: LocalStrings.selectClient.tr,
                                onChanged: (value) {
                                  controller.relationIdController.text =
                                      value.toString();
                                },
                                items: controller.customersModel.data!
                                    .map((value) {
                                  return DropdownMenuItem(
                                    value: value.userId,
                                    child: Text(
                                      value.company ?? '',
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
                    ),
                  if (controller.taskRelatedController.text == 'project')
                    Padding(
                      padding: const EdgeInsets.only(top: Dimensions.space15),
                      child: FutureBuilder(
                          future:
                              projectsMemoizer.runOnce(controller.loadProjects),
                          builder: (context, projectList) {
                            if (projectList.data?.status ?? false) {
                              return CustomDropDownTextField(
                                hintText: LocalStrings.selectProject.tr,
                                onChanged: (value) {
                                  controller.relationIdController.text =
                                      value.toString();
                                },
                                items:
                                    controller.projectsModel.data!.map((value) {
                                  return DropdownMenuItem(
                                    value: value.id,
                                    child: Text(
                                      value.name ?? '',
                                      style: regularDefault.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color),
                                    ),
                                  );
                                }).toList(),
                              );
                            } else if (projectList.data?.status == false) {
                              return CustomDropDownWithTextField(
                                  selectedValue: LocalStrings.noProjectFound.tr,
                                  list: [LocalStrings.noProjectFound.tr]);
                            } else {
                              return const CustomLoader(isFullScreen: false);
                            }
                          }),
                    ),
                  if (controller.taskRelatedController.text == 'invoice')
                    Padding(
                      padding: const EdgeInsets.only(top: Dimensions.space15),
                      child: FutureBuilder(
                          future:
                              invoicesMemoizer.runOnce(controller.loadInvoices),
                          builder: (context, invoiceList) {
                            if (invoiceList.data?.status ?? false) {
                              return CustomDropDownTextField(
                                hintText: LocalStrings.selectInvoice.tr,
                                onChanged: (value) {
                                  controller.relationIdController.text =
                                      value.toString();
                                },
                                items:
                                    controller.invoicesModel.data!.map((value) {
                                  return DropdownMenuItem(
                                    value: value.id,
                                    child: Text(
                                      value.number ?? '',
                                      style: regularDefault.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color),
                                    ),
                                  );
                                }).toList(),
                              );
                            } else if (invoiceList.data?.status == false) {
                              return CustomDropDownWithTextField(
                                  selectedValue: LocalStrings.noInvoiceFound.tr,
                                  list: [LocalStrings.noInvoiceFound.tr]);
                            } else {
                              return const CustomLoader(isFullScreen: false);
                            }
                          }),
                    ),
                  if (controller.taskRelatedController.text == 'lead')
                    Padding(
                      padding: const EdgeInsets.only(top: Dimensions.space15),
                      child: FutureBuilder(
                          future: leadsMemoizer.runOnce(controller.loadLeads),
                          builder: (context, leadList) {
                            if (leadList.data?.status ?? false) {
                              return CustomDropDownTextField(
                                hintText: LocalStrings.selectLead.tr,
                                onChanged: (value) {
                                  controller.relationIdController.text =
                                      value.toString();
                                },
                                items: controller.leadsModel.data!.map((value) {
                                  return DropdownMenuItem(
                                    value: value.id,
                                    child: Text(
                                      value.company ?? '',
                                      style: regularDefault.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color),
                                    ),
                                  );
                                }).toList(),
                              );
                            } else if (leadList.data?.status == false) {
                              return CustomDropDownWithTextField(
                                  selectedValue: LocalStrings.noLeadFound.tr,
                                  list: [LocalStrings.noLeadFound.tr]);
                            } else {
                              return const CustomLoader(isFullScreen: false);
                            }
                          }),
                    ),
                  if (controller.taskRelatedController.text == 'contract')
                    Padding(
                      padding: const EdgeInsets.only(top: Dimensions.space15),
                      child: FutureBuilder(
                          future: contractsMemoizer
                              .runOnce(controller.loadContracts),
                          builder: (context, contractList) {
                            if (contractList.data?.status ?? false) {
                              return CustomDropDownTextField(
                                hintText: LocalStrings.selectContract.tr,
                                onChanged: (value) {
                                  controller.relationIdController.text =
                                      value.toString();
                                },
                                items: controller.contractsModel.data!
                                    .map((value) {
                                  return DropdownMenuItem(
                                    value: value.id,
                                    child: Text(
                                      value.company ?? '',
                                      style: regularDefault.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color),
                                    ),
                                  );
                                }).toList(),
                              );
                            } else if (contractList.data?.status == false) {
                              return CustomDropDownWithTextField(
                                  selectedValue:
                                      LocalStrings.noContractFound.tr,
                                  list: [LocalStrings.noContractFound.tr]);
                            } else {
                              return const CustomLoader(isFullScreen: false);
                            }
                          }),
                    ),
                  if (controller.taskRelatedController.text == 'estimate')
                    Padding(
                      padding: const EdgeInsets.only(top: Dimensions.space15),
                      child: FutureBuilder(
                          future: estimatesMemoizer
                              .runOnce(controller.loadEstimates),
                          builder: (context, estimateList) {
                            if (estimateList.data?.status ?? false) {
                              return CustomDropDownTextField(
                                hintText: LocalStrings.selectEstimate.tr,
                                onChanged: (value) {
                                  controller.relationIdController.text =
                                      value.toString();
                                },
                                items: controller.estimatesModel.data!
                                    .map((value) {
                                  return DropdownMenuItem(
                                    value: value.id,
                                    child: Text(
                                      value.number ?? '',
                                      style: regularDefault.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color),
                                    ),
                                  );
                                }).toList(),
                              );
                            } else if (estimateList.data?.status == false) {
                              return CustomDropDownWithTextField(
                                  selectedValue:
                                      LocalStrings.noEstimateFound.tr,
                                  list: [LocalStrings.noEstimateFound.tr]);
                            } else {
                              return const CustomLoader(isFullScreen: false);
                            }
                          }),
                    ),
                  if (controller.taskRelatedController.text == 'proposal')
                    Padding(
                      padding: const EdgeInsets.only(top: Dimensions.space15),
                      child: FutureBuilder(
                          future: proposalsMemoizer
                              .runOnce(controller.loadProposals),
                          builder: (context, proposalList) {
                            if (proposalList.data?.status ?? false) {
                              return CustomDropDownTextField(
                                hintText: LocalStrings.selectProposal.tr,
                                onChanged: (value) {
                                  controller.relationIdController.text =
                                      value.toString();
                                },
                                items: controller.proposalsModel.data!
                                    .map((value) {
                                  return DropdownMenuItem(
                                    value: value.id,
                                    child: Text(
                                      value.subject ?? '',
                                      style: regularDefault.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color),
                                    ),
                                  );
                                }).toList(),
                              );
                            } else if (proposalList.data?.status == false) {
                              return CustomDropDownWithTextField(
                                  selectedValue:
                                      LocalStrings.noProposalFound.tr,
                                  list: [LocalStrings.noProposalFound.tr]);
                            } else {
                              return const CustomLoader(isFullScreen: false);
                            }
                          }),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: Dimensions.space15),
                    child: CustomTextField(
                      labelText: LocalStrings.tags.tr,
                      controller: controller.tagsController,
                      focusNode: controller.tagsFocusNode,
                      textInputType: TextInputType.text,
                      nextFocus: controller.descriptionFocusNode,
                      onChanged: (value) {
                        return;
                      },
                    ),
                  ),
                  const SizedBox(height: Dimensions.space15),
                  CustomTextField(
                    labelText: LocalStrings.description.tr,
                    controller: controller.descriptionController,
                    focusNode: controller.descriptionFocusNode,
                    textInputType: TextInputType.text,
                    maxLines: 3,
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
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10),
        child: GetBuilder<TaskController>(builder: (controller) {
          return controller.isSubmitLoading
              ? const RoundedLoadingBtn()
              : RoundedButton(
                  text: LocalStrings.submit.tr,
                  press: () {
                    controller.submitTask();
                  },
                );
        }),
      ),
    );
  }
}
