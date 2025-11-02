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
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/customer/model/customer_model.dart';
import 'package:flutex_admin/features/expense/controller/expense_controller.dart';
import 'package:flutex_admin/features/expense/model/expense_category_model.dart';
import 'package:flutex_admin/features/expense/repo/expense_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateExpenseScreen extends StatefulWidget {
  const UpdateExpenseScreen({super.key, required this.id});
  final String id;

  @override
  State<UpdateExpenseScreen> createState() => _UpdateExpenseScreenState();
}

class _UpdateExpenseScreenState extends State<UpdateExpenseScreen> {
  final formKey = GlobalKey<FormState>();
  final AsyncMemoizer<CustomersModel> customersMemoizer = AsyncMemoizer();
  final AsyncMemoizer<ExpenseCategoryModel> expenseCategoryMemoizer =
      AsyncMemoizer();

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ExpenseRepo(apiClient: Get.find()));
    final controller = Get.put(ExpenseController(expenseRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadExpenseUpdateData(widget.id);
    });
  }

  @override
  void dispose() {
    Get.find<ExpenseController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: LocalStrings.updateExpense.tr),
      body: GetBuilder<ExpenseController>(
        builder: (controller) {
          return controller.isLoading
              ? const CustomLoader()
              : RefreshIndicator(
                  color: ColorResources.primaryColor,
                  onRefresh: () async {
                    await controller.loadExpenseUpdateData(widget.id);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.space15,
                        horizontal: Dimensions.space10,
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          spacing: Dimensions.space15,
                          children: [
                            CustomTextField(
                              labelText: LocalStrings.name.tr,
                              controller: controller.nameController,
                              focusNode: controller.nameFocusNode,
                              textInputType: TextInputType.text,
                              nextFocus: controller.categoryFocusNode,
                              onChanged: (value) {
                                return;
                              },
                            ),
                            FutureBuilder(
                              future: customersMemoizer.runOnce(
                                controller.loadCustomers,
                              ),
                              builder: (context, customerList) {
                                if (customerList.data?.status ?? false) {
                                  return CustomDropDownTextField(
                                    hintText: LocalStrings.selectClient.tr,
                                    onChanged: (value) {
                                      controller.customerIdController.text =
                                          value;
                                    },
                                    selectedValue:
                                        controller.customerIdController.text,
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
                                    selectedValue:
                                        LocalStrings.noClientFound.tr,
                                    list: [LocalStrings.noClientFound.tr],
                                  );
                                } else {
                                  return const CustomLoader();
                                }
                              },
                            ),
                            FutureBuilder(
                              future: expenseCategoryMemoizer.runOnce(
                                controller.loadExpenseCategory,
                              ),
                              builder: (context, expenseCategoryList) {
                                if (expenseCategoryList.data?.status ?? false) {
                                  return CustomDropDownTextField(
                                    hintText:
                                        LocalStrings.selectExpenseCategory.tr,
                                    /*validator: (value) {
                                if (controller.categoryController.text.isEmpty) {
                                  return '${LocalStrings.expenseCategory.tr} ${LocalStrings.isRequired.tr}';
                                } else {
                                  return null;
                                }
                              },*/
                                    onChanged: (value) {
                                      controller.categoryController.text =
                                          value;
                                      controller.update();
                                      //setState(() {});
                                    },
                                    selectedValue:
                                        controller.categoryController.text,
                                    items: controller.expenseCategoryModel.data!
                                        .map(
                                          (category) => DropdownMenuItem(
                                            value: category.id,
                                            child: Text(
                                              category.name ?? '',
                                              style: regularDefault.copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium!.color,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  );
                                } else if (expenseCategoryList.data?.status ==
                                    false) {
                                  return CustomDropDownWithTextField(
                                    selectedValue:
                                        LocalStrings.noExpenseCategoryFound.tr,
                                    list: [
                                      LocalStrings.noExpenseCategoryFound.tr,
                                    ],
                                  );
                                } else {
                                  return const CustomLoader();
                                }
                              },
                            ),
                            CustomDateFormField(
                              labelText: LocalStrings.date.tr,
                              initialValue:
                                  DateConverter.convertStringToDatetime(
                                    controller.dateController.text,
                                  ),
                              validator: (value) {
                                if (controller.dateController.text.isEmpty) {
                                  return '${LocalStrings.date.tr} ${LocalStrings.isRequired.tr}';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (DateTime? value) {
                                controller.dateController.text =
                                    DateConverter.formatDate(value!);
                              },
                            ),
                            CustomTextField(
                              labelText: LocalStrings.amount.tr,
                              controller: controller.amountController,
                              focusNode: controller.amountFocusNode,
                              textInputType: TextInputType.number,
                              nextFocus: controller.noteFocusNode,
                              validator: (value) {
                                if (controller.amountController.text.isEmpty) {
                                  return '${LocalStrings.amount.tr} ${LocalStrings.isRequired.tr}';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {
                                return;
                              },
                            ),
                            CustomTextField(
                              labelText: LocalStrings.note.tr,
                              textInputType: TextInputType.multiline,
                              maxLines: 3,
                              focusNode: controller.noteFocusNode,
                              controller: controller.noteController,
                              onChanged: (value) {
                                return;
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(Dimensions.space10),
        child: GetBuilder<ExpenseController>(
          builder: (controller) {
            return controller.isLoading
                ? const SizedBox.shrink()
                : controller.isSubmitLoading
                ? const RoundedLoadingBtn()
                : RoundedButton(
                    text: LocalStrings.update.tr,
                    press: () {
                      if (formKey.currentState!.validate()) {
                        controller.submitExpense(
                          expenseId: widget.id,
                          isUpdate: true,
                        );
                      }
                    },
                  );
          },
        ),
      ),
    );
  }
}
