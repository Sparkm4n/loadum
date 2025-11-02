import 'package:async/async.dart';
import 'package:flutex_admin/common/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/common/components/buttons/rounded_button.dart';
import 'package:flutex_admin/common/components/buttons/rounded_loading_button.dart';
import 'package:flutex_admin/common/components/custom_drop_down_button_with_text_field.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_drop_down_text_field.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_text_field.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/customer/model/customer_model.dart';
import 'package:flutex_admin/features/ticket/controller/ticket_controller.dart';
import 'package:flutex_admin/features/ticket/model/departments_model.dart';
import 'package:flutex_admin/features/ticket/model/priorities_model.dart';
import 'package:flutex_admin/features/ticket/model/services_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTicketScreen extends StatefulWidget {
  const AddTicketScreen({super.key});

  @override
  State<AddTicketScreen> createState() => _AddTicketScreenState();
}

class _AddTicketScreenState extends State<AddTicketScreen> {
  final AsyncMemoizer<CustomersModel> customersMemoizer = AsyncMemoizer();
  final AsyncMemoizer<DepartmentModel> departmentMemoizer = AsyncMemoizer();
  final AsyncMemoizer<PriorityModel> priorityMemoizer = AsyncMemoizer();
  final AsyncMemoizer<ServiceModel> serviceMemoizer = AsyncMemoizer();

  @override
  void dispose() {
    Get.find<TicketController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: LocalStrings.createNewTicket.tr),
      body: GetBuilder<TicketController>(
        builder: (controller) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Dimensions.space15,
                horizontal: Dimensions.space10,
              ),
              child: Column(
                children: [
                  CustomTextField(
                    labelText: LocalStrings.subject.tr,
                    controller: controller.subjectController,
                    focusNode: controller.subjectFocusNode,
                    textInputType: TextInputType.text,
                    nextFocus: controller.userFocusNode,
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
                  const SizedBox(height: Dimensions.space15),
                  FutureBuilder(
                    future: customersMemoizer.runOnce(controller.loadCustomers),
                    builder: (context, customerList) {
                      if (customerList.data?.status ?? false) {
                        return CustomDropDownTextField(
                          hintText: LocalStrings.selectClient.tr,
                          onChanged: (value) {
                            controller.userController.text = value;
                            controller.selectedCustomer = value;
                            controller.update();
                          },
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
                        return const CustomLoader(isFullScreen: false);
                      }
                    },
                  ),
                  if (controller.selectedCustomer.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: Dimensions.space15),
                      child: FutureBuilder(
                        future: controller.loadCustomerContacts(
                          controller.selectedCustomer,
                        ),
                        builder: (context, contactsList) {
                          if (contactsList.data?.status ?? false) {
                            return CustomDropDownTextField(
                              hintText: LocalStrings.selectContact.tr,
                              onChanged: (value) {
                                controller.contactController.text = value;
                              },
                              items: controller.contactsModel.data!.map((
                                contact,
                              ) {
                                return DropdownMenuItem(
                                  value: contact.id,
                                  child: Text(
                                    '${contact.firstName ?? ''} ${contact.lastName ?? ''}',
                                    style: regularDefault.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.color,
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          } else if (contactsList.data?.status == false) {
                            return CustomDropDownWithTextField(
                              selectedValue: LocalStrings.noContactFound.tr,
                              list: [LocalStrings.noContactFound.tr],
                            );
                          } else {
                            return const CustomLoader(isFullScreen: false);
                          }
                        },
                      ),
                    ),
                  const SizedBox(height: Dimensions.space15),
                  FutureBuilder(
                    future: departmentMemoizer.runOnce(
                      controller.loadDepartments,
                    ),
                    builder: (context, departmentList) {
                      if (departmentList.data?.status ?? false) {
                        return CustomDropDownTextField(
                          hintText: LocalStrings.selectDepartment.tr,
                          onChanged: (value) {
                            controller.departmentController.text = value;
                          },
                          items: controller.departmentModel.data!.map((
                            department,
                          ) {
                            return DropdownMenuItem(
                              value: department.id,
                              child: Text(
                                department.name ?? '',
                                style: regularDefault.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.color,
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      } else if (departmentList.data?.status == false) {
                        return CustomDropDownWithTextField(
                          selectedValue: LocalStrings.noDepartmentFound.tr,
                          list: [LocalStrings.noDepartmentFound.tr],
                        );
                      } else {
                        return const CustomLoader(isFullScreen: false);
                      }
                    },
                  ),
                  const SizedBox(height: Dimensions.space15),
                  FutureBuilder(
                    future: priorityMemoizer.runOnce(controller.loadPriorities),
                    builder: (context, prioritiesList) {
                      if (prioritiesList.data?.status ?? false) {
                        return CustomDropDownTextField(
                          hintText: LocalStrings.selectPriority.tr,
                          onChanged: (value) {
                            controller.priorityController.text = value;
                          },
                          items: controller.priorityModel.data!.map((priority) {
                            return DropdownMenuItem(
                              value: priority.id,
                              child: Text(
                                priority.name ?? '',
                                style: regularDefault.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.color,
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      } else if (prioritiesList.data?.status == false) {
                        return CustomDropDownWithTextField(
                          selectedValue: LocalStrings.noPriorityFound.tr,
                          list: [LocalStrings.noPriorityFound.tr],
                        );
                      } else {
                        return const CustomLoader(isFullScreen: false);
                      }
                    },
                  ),
                  const SizedBox(height: Dimensions.space15),
                  FutureBuilder(
                    future: serviceMemoizer.runOnce(controller.loadServices),
                    builder: (context, servicesList) {
                      if (servicesList.data?.status ?? false) {
                        return CustomDropDownTextField(
                          hintText: LocalStrings.selectService.tr,
                          onChanged: (value) {
                            controller.serviceController.text = value;
                          },
                          items: controller.serviceModel.data!.map((service) {
                            return DropdownMenuItem(
                              value: service.id,
                              child: Text(
                                service.name ?? '',
                                style: regularDefault.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.color,
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      } else if (servicesList.data?.status == false) {
                        return CustomDropDownWithTextField(
                          selectedValue: LocalStrings.noServiceFound.tr,
                          list: [LocalStrings.noServiceFound.tr],
                        );
                      } else {
                        return const CustomLoader(isFullScreen: false);
                      }
                    },
                  ),
                  const SizedBox(height: Dimensions.space15),
                  CustomTextField(
                    labelText: LocalStrings.description.tr,
                    textInputType: TextInputType.multiline,
                    maxLines: 4,
                    focusNode: controller.descriptionFocusNode,
                    controller: controller.descriptionController,
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
                            controller.submitTicket(context);
                          },
                        ),
                  const SizedBox(height: Dimensions.space10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
