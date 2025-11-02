import 'package:async/async.dart';
import 'package:flutex_admin/common/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/common/components/buttons/add_icon_button.dart';
import 'package:flutex_admin/common/components/buttons/rounded_button.dart';
import 'package:flutex_admin/common/components/buttons/rounded_loading_button.dart';
import 'package:flutex_admin/common/components/custom_date_form_field.dart';
import 'package:flutex_admin/common/components/custom_drop_down_button_with_text_field.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_drop_down_text_field.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_multi_drop_down_text_field.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_text_field.dart';
import 'package:flutex_admin/common/models/currencies_model.dart';
import 'package:flutex_admin/common/models/payment_modes_model.dart';
import 'package:flutex_admin/core/helper/date_converter.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/customer/model/customer_model.dart';
import 'package:flutex_admin/features/invoice/controller/invoice_controller.dart';
import 'package:flutex_admin/features/invoice/repo/invoice_repo.dart';
import 'package:flutex_admin/features/item/model/item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class UpdateInvoiceScreen extends StatefulWidget {
  const UpdateInvoiceScreen({super.key, required this.id});
  final String id;

  @override
  State<UpdateInvoiceScreen> createState() => _UpdateInvoiceScreenState();
}

class _UpdateInvoiceScreenState extends State<UpdateInvoiceScreen> {
  final formKey = GlobalKey<FormState>();
  final itemFormKey = GlobalKey<FormState>();
  final AsyncMemoizer<CustomersModel> customersMemoizer = AsyncMemoizer();
  final AsyncMemoizer<CurrenciesModel> currenciesMemoizer = AsyncMemoizer();
  final AsyncMemoizer<PaymentModesModel> paymentModesMemoizer = AsyncMemoizer();
  final AsyncMemoizer<ItemsModel> itemsMemoizer = AsyncMemoizer();

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(InvoiceRepo(apiClient: Get.find()));
    final controller = Get.put(InvoiceController(invoiceRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadInvoiceUpdateData(widget.id);
    });
  }

  @override
  void dispose() {
    Get.find<InvoiceController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvoiceController>(
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppBar(title: LocalStrings.updateInvoice.tr),
          body: controller.isLoading
              ? const CustomLoader()
              : RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).cardColor,
                  onRefresh: () async {
                    await controller.loadInvoiceUpdateData(widget.id);
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
                              labelText: LocalStrings.number.tr,
                              controller: controller.numberController,
                              focusNode: controller.numberFocusNode,
                              textInputType: TextInputType.number,
                              nextFocus: controller.clientFocusNode,
                              prefix: Text(
                                controller.settingsModel.data?.invoicePrefix ??
                                    '',
                                style: boldDefault.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.color,
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return '${LocalStrings.invoice.tr} ${LocalStrings.number.tr} ${LocalStrings.isRequired.tr}';
                                } else {
                                  return null;
                                }
                              },
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
                                      final customer = value as Customer;
                                      controller.clientController.text =
                                          customer.userId ?? '';
                                      controller.billingStreetController.text =
                                          customer.billingStreet ?? '';
                                      controller.currencyController.text =
                                          customer.defaultCurrency == '0'
                                          ? controller
                                                    .settingsModel
                                                    .data
                                                    ?.currency
                                                    ?.id ??
                                                '0'
                                          : customer.defaultCurrency ?? '0';
                                      controller.update();
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return '${LocalStrings.client.tr} ${LocalStrings.isRequired.tr}';
                                      } else {
                                        return null;
                                      }
                                    },
                                    items: controller.customersModel.data!.map((
                                      customer,
                                    ) {
                                      return DropdownMenuItem(
                                        value: customer,
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
                                  return const CustomLoader(
                                    isFullScreen: false,
                                  );
                                }
                              },
                            ),

                            // Invoice Date
                            Row(
                              children: [
                                Expanded(
                                  child: CustomDateFormField(
                                    labelText: LocalStrings.date.tr,
                                    initialValue:
                                        DateConverter.convertStringToDatetime(
                                          controller.dateController.text,
                                        ),
                                    onChanged: (DateTime? value) {
                                      controller.dateController.text =
                                          DateConverter.formatDate(value!);
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return '${LocalStrings.date.tr} ${LocalStrings.isRequired.tr}';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: Dimensions.space5),
                                Expanded(
                                  child: CustomDateFormField(
                                    labelText: LocalStrings.dueDate.tr,
                                    initialValue:
                                        controller
                                            .dueDateController
                                            .text
                                            .isNotEmpty
                                        ? DateConverter.convertStringToDatetime(
                                            controller.dueDateController.text,
                                          )
                                        : null,
                                    onChanged: (DateTime? value) {
                                      controller.dueDateController.text =
                                          DateConverter.formatDate(value!);
                                    },
                                  ),
                                ),
                              ],
                            ),

                            CustomTextField(
                              labelText: LocalStrings.billingStreet.tr,
                              controller: controller.billingStreetController,
                              focusNode: controller.billingStreetFocusNode,
                              textInputType: TextInputType.text,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return '${LocalStrings.billingStreet.tr} ${LocalStrings.isRequired.tr}';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {
                                return;
                              },
                            ),

                            FutureBuilder(
                              future: currenciesMemoizer.runOnce(
                                controller.loadCurrencies,
                              ),
                              builder: (context, currenciesList) {
                                if (currenciesList.data?.status ?? false) {
                                  return CustomDropDownTextField(
                                    hintText: LocalStrings.selectCurrency.tr,
                                    selectedValue:
                                        controller.currencyController.text,
                                    onChanged: (value) {
                                      controller.currencyController.text =
                                          value;
                                    },
                                    items: controller.currenciesModel.data!.map(
                                      (currency) {
                                        return DropdownMenuItem(
                                          value: currency.id,
                                          child: Text(
                                            currency.name ?? '',
                                            style: regularDefault.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium!.color,
                                            ),
                                          ),
                                        );
                                      },
                                    ).toList(),
                                  );
                                } else if (currenciesList.data?.status ==
                                    false) {
                                  return CustomDropDownWithTextField(
                                    selectedValue:
                                        LocalStrings.noCurrencyFound.tr,
                                    list: [LocalStrings.noCurrencyFound.tr],
                                  );
                                } else {
                                  return const CustomLoader(
                                    isFullScreen: false,
                                  );
                                }
                              },
                            ),

                            FutureBuilder(
                              future: paymentModesMemoizer.runOnce(
                                controller.loadPaymentModes,
                              ),
                              builder: (context, paymentModesList) {
                                if (paymentModesList.data?.status ?? false) {
                                  return CustomMultiDropDownTextField(
                                    controller:
                                        controller.paymentModeController,
                                    hintText: LocalStrings.selectPaymentMode.tr,
                                    onChanged: (options) {
                                      controller.allowedPaymentModesList
                                          .clear();
                                      for (var v in options) {
                                        controller.allowedPaymentModesList.add(
                                          v.toString(),
                                        );
                                      }
                                    },
                                    items: controller.paymentModesModel.data!
                                        .map((value) {
                                          return DropdownItem(
                                            label: value.name?.tr ?? '',
                                            value: value.id!,
                                          );
                                        })
                                        .toList(),
                                  );
                                } else if (paymentModesList.data?.status ==
                                    false) {
                                  return CustomDropDownWithTextField(
                                    selectedValue:
                                        LocalStrings.noPaymentModeFound.tr,
                                    list: [LocalStrings.noPaymentModeFound.tr],
                                  );
                                } else {
                                  return const CustomLoader(
                                    isFullScreen: false,
                                  );
                                }
                              },
                            ),

                            const CustomDivider(space: Dimensions.space1),

                            // Items Section Start
                            Row(
                              children: [
                                Container(
                                  width: Dimensions.space3,
                                  height: Dimensions.space15,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: Dimensions.space5),
                                Text(
                                  LocalStrings.items.tr,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Text(
                                        '${LocalStrings.showQuantityAs.tr}:',
                                        style: lightSmall.copyWith(
                                          color: ColorResources.blueGreyColor,
                                        ),
                                      ),
                                      const SizedBox(width: Dimensions.space5),
                                      const Icon(
                                        Icons.circle,
                                        size: Dimensions.space15,
                                        color: ColorResources.blueGreyColor,
                                      ),
                                      Text(
                                        ' ${LocalStrings.qty.tr}',
                                        style: lightSmall.copyWith(
                                          color: ColorResources.blueGreyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              spacing: Dimensions.space5,
                              children: [
                                Expanded(
                                  flex: 10,
                                  child: FutureBuilder(
                                    future: itemsMemoizer.runOnce(
                                      controller.loadItems,
                                    ),
                                    builder: (context, itemsList) {
                                      if (itemsList.data?.status ?? false) {
                                        return CustomDropDownTextField(
                                          hintText: LocalStrings.addItem.tr,
                                          onChanged: (value) {
                                            final item = value as Item;
                                            controller.itemController.text =
                                                item.description ?? '';
                                            controller
                                                    .descriptionController
                                                    .text =
                                                item.longDescription ?? '';
                                            controller.qtyController.text = '1';
                                            controller.unitController.text =
                                                item.unit ?? '';
                                            controller.rateController.text =
                                                item.rate ?? '';
                                            controller.update();
                                          },
                                          items: controller.itemsModel.data!
                                              .map((Item item) {
                                                return DropdownMenuItem(
                                                  value: item,
                                                  child: Text(
                                                    item.description ?? '',
                                                    style: regularDefault
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .color,
                                                        ),
                                                  ),
                                                );
                                              })
                                              .toList(),
                                        );
                                      } else if (itemsList.data?.status ==
                                          false) {
                                        return CustomDropDownWithTextField(
                                          selectedValue:
                                              LocalStrings.noItemFound.tr,
                                          list: [LocalStrings.noItemFound.tr],
                                        );
                                      } else {
                                        return const CustomLoader(
                                          isFullScreen: false,
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: AddIconButton(
                                    onTap: () {
                                      // TODO: Open BottomSheet to Add New Item Then recall loadItems
                                    },
                                  ),
                                ),
                              ],
                            ),

                            Container(
                              padding: const EdgeInsets.all(Dimensions.space15),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: ColorResources.blueGreyColor,
                                ),
                                borderRadius: BorderRadius.circular(
                                  Dimensions.space10,
                                ),
                              ),
                              child: Form(
                                key: itemFormKey,
                                child: Column(
                                  spacing: Dimensions.space15,
                                  children: [
                                    CustomTextField(
                                      labelText: LocalStrings.itemName.tr,
                                      controller: controller.itemController,
                                      focusNode: controller.itemFocusNode,
                                      textInputType: TextInputType.text,
                                      nextFocus:
                                          controller.descriptionFocusNode,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return '${LocalStrings.itemName.tr} ${LocalStrings.isRequired.tr}';
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
                                      textInputType: TextInputType.text,
                                      controller:
                                          controller.descriptionController,
                                      focusNode:
                                          controller.descriptionFocusNode,
                                      nextFocus: controller.qtyFocusNode,
                                      onChanged: (value) {
                                        return;
                                      },
                                    ),
                                    Row(
                                      spacing: Dimensions.space5,
                                      children: [
                                        Flexible(
                                          flex: 4,
                                          child: CustomTextField(
                                            labelText: LocalStrings.qty.tr,
                                            textInputType: TextInputType.number,
                                            controller:
                                                controller.qtyController,
                                            focusNode: controller.qtyFocusNode,
                                            nextFocus: controller.unitFocusNode,
                                            onChanged: (value) {
                                              return;
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: CustomTextField(
                                            labelText: LocalStrings.unit.tr,
                                            textInputType: TextInputType.text,
                                            controller:
                                                controller.unitController,
                                            focusNode: controller.unitFocusNode,
                                            nextFocus: controller.rateFocusNode,
                                            onChanged: (value) {
                                              return;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      spacing: Dimensions.space5,
                                      children: [
                                        Flexible(
                                          flex: 4,
                                          child: CustomTextField(
                                            labelText: LocalStrings.rate.tr,
                                            textInputType: TextInputType.number,
                                            focusNode: controller.rateFocusNode,
                                            controller:
                                                controller.rateController,
                                            onChanged: (value) {
                                              return;
                                            },
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return '${LocalStrings.rate.tr} ${LocalStrings.isRequired.tr}';
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: AddIconButton(
                                            text: LocalStrings.addItem.tr,
                                            icon: Icons.check,
                                            iconSize: 20,
                                            onTap: () {
                                              if (itemFormKey.currentState!
                                                  .validate()) {
                                                controller.increaseItemField();
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            if (controller.invoiceItemList.isNotEmpty)
                              ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.invoiceItemList.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: Dimensions.space15),
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.all(
                                      Dimensions.space15,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: ColorResources.blueGreyColor,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        Dimensions.space10,
                                      ),
                                    ),
                                    child: Column(
                                      spacing: Dimensions.space15,
                                      children: [
                                        CustomTextField(
                                          labelText: LocalStrings.itemName.tr,
                                          controller: controller
                                              .invoiceItemList[index]
                                              .itemNameController,
                                          textInputType: TextInputType.text,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return LocalStrings
                                                  .enterItemName
                                                  .tr;
                                            } else {
                                              return null;
                                            }
                                          },
                                          onChanged: (value) {
                                            return;
                                          },
                                        ),
                                        CustomTextField(
                                          labelText:
                                              LocalStrings.description.tr,
                                          textInputType: TextInputType.text,
                                          controller: controller
                                              .invoiceItemList[index]
                                              .descriptionController,
                                          onChanged: (value) {
                                            return;
                                          },
                                        ),
                                        Row(
                                          spacing: Dimensions.space5,
                                          children: [
                                            Flexible(
                                              flex: 4,
                                              child: CustomTextField(
                                                labelText: LocalStrings.qty.tr,
                                                textInputType:
                                                    TextInputType.number,
                                                controller: controller
                                                    .invoiceItemList[index]
                                                    .qtyController,
                                                onChanged: (value) {
                                                  return;
                                                },
                                              ),
                                            ),
                                            Flexible(
                                              flex: 2,
                                              child: CustomTextField(
                                                labelText: LocalStrings.unit.tr,
                                                textInputType:
                                                    TextInputType.text,
                                                controller: controller
                                                    .invoiceItemList[index]
                                                    .unitController,
                                                onChanged: (value) {
                                                  return;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          spacing: Dimensions.space5,
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: CustomTextField(
                                                labelText: LocalStrings.rate.tr,
                                                textInputType:
                                                    TextInputType.number,
                                                controller: controller
                                                    .invoiceItemList[index]
                                                    .rateController,
                                                onChanged: (value) {
                                                  controller
                                                      .calculateInvoiceAmount();
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return LocalStrings
                                                        .enterRate
                                                        .tr;
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: AddIconButton(
                                                text:
                                                    LocalStrings.removeItem.tr,
                                                icon: Icons.highlight_remove,
                                                iconSize: 20,
                                                color: ColorResources.colorRed,
                                                onTap: () {
                                                  controller.decreaseItemField(
                                                    index,
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                            CustomTextField(
                              labelText: LocalStrings.clientNote.tr,
                              controller: controller.clientNoteController,
                              focusNode: controller.clientNoteFocusNode,
                              textInputType: TextInputType.multiline,
                              maxLines: 4,
                              nextFocus: controller.termsFocusNode,
                              onChanged: (value) {
                                return;
                              },
                            ),

                            CustomTextField(
                              labelText: LocalStrings.terms.tr,
                              controller: controller.termsController,
                              focusNode: controller.termsFocusNode,
                              textInputType: TextInputType.multiline,
                              maxLines: 4,
                              onChanged: (value) {
                                return;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(Dimensions.space10),
            child: controller.isLoading
                ? const SizedBox.shrink()
                : controller.isSubmitLoading
                ? const RoundedLoadingBtn()
                : RoundedButton(
                    text: LocalStrings.update.tr,
                    press: () {
                      controller.submitInvoice(
                        invoiceId: widget.id,
                        isUpdate: true,
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
