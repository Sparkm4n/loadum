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
import 'package:flutex_admin/common/components/text-form-field/custom_text_field.dart';
import 'package:flutex_admin/common/models/currencies_model.dart';
import 'package:flutex_admin/core/helper/date_converter.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/customer/model/customer_model.dart';
import 'package:flutex_admin/features/item/model/item_model.dart';
import 'package:flutex_admin/features/lead/model/lead_model.dart';
import 'package:flutex_admin/features/proposal/controller/proposal_controller.dart';
import 'package:flutex_admin/features/proposal/repo/proposal_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProposalScreen extends StatefulWidget {
  const AddProposalScreen({super.key});

  @override
  State<AddProposalScreen> createState() => _AddProposalScreenState();
}

class _AddProposalScreenState extends State<AddProposalScreen> {
  final formKey = GlobalKey<FormState>();
  final itemFormKey = GlobalKey<FormState>();
  final AsyncMemoizer<CustomersModel> customersMemoizer = AsyncMemoizer();
  final AsyncMemoizer<LeadsModel> leadsMemoizer = AsyncMemoizer();
  final AsyncMemoizer<CurrenciesModel> currenciesMemoizer = AsyncMemoizer();
  final AsyncMemoizer<ItemsModel> itemsMemoizer = AsyncMemoizer();

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ProposalRepo(apiClient: Get.find()));
    final controller = Get.put(ProposalController(proposalRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadProposalCreateData();
    });
  }

  @override
  void dispose() {
    Get.find<ProposalController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProposalController>(
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppBar(title: LocalStrings.addProposal.tr),
          body: SingleChildScrollView(
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
                      labelText: LocalStrings.subject.tr,
                      controller: controller.subjectController,
                      focusNode: controller.subjectFocusNode,
                      textInputType: TextInputType.text,
                      nextFocus: controller.clientNameFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return '${LocalStrings.subject.tr} ${LocalStrings.isRequired.tr}';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        return;
                      },
                    ),

                    CustomDropDownTextField(
                      hintText: LocalStrings.relatedTo.tr,
                      onChanged: (value) {
                        controller.proposalRelatedController.text = value;
                        controller.update();
                      },
                      selectedValue: controller.proposalRelatedController.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return '${LocalStrings.relatedTo.tr} ${LocalStrings.isRequired.tr}';
                        } else {
                          return null;
                        }
                      },
                      items: controller.proposalRelated.entries
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
                    if (controller.proposalRelatedController.text == 'lead')
                      FutureBuilder(
                        future: leadsMemoizer.runOnce(controller.loadLeads),
                        builder: (context, leadList) {
                          if (leadList.data?.status ?? false) {
                            return CustomDropDownTextField(
                              hintText: LocalStrings.selectLead.tr,
                              onChanged: (value) {
                                final lead = value as Lead;
                                controller.clientController.text =
                                    lead.id ?? '';
                                controller.clientNameController.text =
                                    lead.company ?? '';
                                controller.clientEmailController.text =
                                    lead.email ?? '';
                                controller.currencyController.text =
                                    controller
                                        .settingsModel
                                        .data
                                        ?.currency
                                        ?.id ??
                                    '0';
                              },
                              validator: (value) {
                                if (controller.proposalRelatedController.text ==
                                        'lead' &&
                                    value == null) {
                                  return '${LocalStrings.lead.tr} ${LocalStrings.isRequired.tr}';
                                } else {
                                  return null;
                                }
                              },
                              items: controller.leadsModel.data!.map((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(
                                    value.company ?? '',
                                    style: regularDefault.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.color,
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          } else if (leadList.data?.status == false) {
                            return CustomDropDownWithTextField(
                              selectedValue: LocalStrings.noLeadFound.tr,
                              list: [LocalStrings.noLeadFound.tr],
                            );
                          } else {
                            return const CustomLoader(isFullScreen: false);
                          }
                        },
                      ),
                    if (controller.proposalRelatedController.text == 'customer')
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
                                    customer.userId!;
                                controller.clientNameController.text =
                                    customer.company ?? '';
                                //controller.clientEmailController.text =
                                //    customer.email ?? '';
                                controller.currencyController.text =
                                    customer.defaultCurrency == '0'
                                    ? controller
                                              .settingsModel
                                              .data
                                              ?.currency
                                              ?.id ??
                                          '0'
                                    : customer.defaultCurrency ?? '0';
                              },
                              validator: (value) {
                                if (controller.proposalRelatedController.text ==
                                        'customer' &&
                                    value == null) {
                                  return '${LocalStrings.client.tr} ${LocalStrings.isRequired.tr}';
                                } else {
                                  return null;
                                }
                              },
                              items: controller.customersModel.data!.map((
                                value,
                              ) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(
                                    value.company ?? '',
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

                    CustomTextField(
                      labelText: LocalStrings.to.tr,
                      controller: controller.clientNameController,
                      focusNode: controller.clientNameFocusNode,
                      textInputType: TextInputType.text,
                      nextFocus: controller.clientEmailFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return '${LocalStrings.to.tr} ${LocalStrings.isRequired.tr}';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        return;
                      },
                    ),

                    CustomTextField(
                      labelText: LocalStrings.email.tr,
                      controller: controller.clientEmailController,
                      focusNode: controller.clientEmailFocusNode,
                      textInputType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return '${LocalStrings.email.tr} ${LocalStrings.isRequired.tr}';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        return;
                      },
                    ),

                    // Proposal Date
                    Row(
                      spacing: Dimensions.space5,
                      children: [
                        Expanded(
                          child: CustomDateFormField(
                            labelText: LocalStrings.date.tr,
                            initialValue: DateTime.now(),
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
                        Expanded(
                          child: CustomDateFormField(
                            labelText: LocalStrings.dueDate.tr,
                            initialValue: DateTime.now().add(
                              Duration(
                                days: int.parse(
                                  controller
                                          .settingsModel
                                          .data
                                          ?.proposalDueAfter ??
                                      '0',
                                ),
                              ),
                            ),
                            onChanged: (DateTime? value) {
                              controller.openTillController.text =
                                  DateConverter.formatDate(value!);
                            },
                          ),
                        ),
                      ],
                    ),

                    CustomDropDownTextField(
                      hintText: LocalStrings.selectStatus.tr,
                      onChanged: (value) {
                        controller.statusController.text = value;
                      },
                      items: controller.proposalStatus.entries
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

                    FutureBuilder(
                      future: currenciesMemoizer.runOnce(
                        controller.loadCurrencies,
                      ),
                      builder: (context, currenciesList) {
                        if (currenciesList.data?.status ?? false) {
                          return CustomDropDownTextField(
                            hintText: LocalStrings.selectCurrency.tr,
                            onChanged: null,
                            //(value) {
                            //  controller.currencyController.text = value;
                            //},
                            selectedValue:
                                controller.currencyController.text.isEmpty
                                ? controller.settingsModel.data?.currency?.id
                                : controller.currencyController.text,
                            items: controller.currenciesModel.data!.map((
                              currency,
                            ) {
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
                            }).toList(),
                          );
                        } else if (currenciesList.data?.status == false) {
                          return CustomDropDownWithTextField(
                            selectedValue: LocalStrings.noCurrencyFound.tr,
                            list: [LocalStrings.noCurrencyFound.tr],
                          );
                        } else {
                          return const CustomLoader(isFullScreen: false);
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
                            future: itemsMemoizer.runOnce(controller.loadItems),
                            builder: (context, itemsList) {
                              if (itemsList.data?.status ?? false) {
                                return CustomDropDownTextField(
                                  hintText: LocalStrings.addItem.tr,
                                  onChanged: (value) {
                                    final item = value as Item;
                                    controller.itemController.text =
                                        item.description ?? '';
                                    controller.descriptionController.text =
                                        item.longDescription ?? '';
                                    controller.qtyController.text = '1';
                                    controller.unitController.text =
                                        item.unit ?? '';
                                    controller.rateController.text =
                                        item.rate ?? '';
                                    controller.update();
                                  },
                                  items: controller.itemsModel.data!.map((
                                    Item item,
                                  ) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Text(
                                        item.description ?? '',
                                        style: regularDefault.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium!.color,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              } else if (itemsList.data?.status == false) {
                                return CustomDropDownWithTextField(
                                  selectedValue: LocalStrings.noItemFound.tr,
                                  list: [LocalStrings.noItemFound.tr],
                                );
                              } else {
                                return const CustomLoader(isFullScreen: false);
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
                        border: Border.all(color: ColorResources.blueGreyColor),
                        borderRadius: BorderRadius.circular(Dimensions.space10),
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
                              nextFocus: controller.descriptionFocusNode,
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
                              controller: controller.descriptionController,
                              focusNode: controller.descriptionFocusNode,
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
                                    controller: controller.qtyController,
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
                                    controller: controller.unitController,
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
                                    controller: controller.rateController,
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

                    if (controller.proposalItemList.isNotEmpty)
                      ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.proposalItemList.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: Dimensions.space15),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(Dimensions.space15),
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
                                      .proposalItemList[index]
                                      .itemNameController,
                                  textInputType: TextInputType.text,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return LocalStrings.enterItemName.tr;
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
                                  controller: controller
                                      .proposalItemList[index]
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
                                        textInputType: TextInputType.number,
                                        controller: controller
                                            .proposalItemList[index]
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
                                        textInputType: TextInputType.text,
                                        controller: controller
                                            .proposalItemList[index]
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
                                        textInputType: TextInputType.number,
                                        controller: controller
                                            .proposalItemList[index]
                                            .rateController,
                                        onChanged: (value) {
                                          controller.calculateProposalAmount();
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return LocalStrings.enterRate.tr;
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: AddIconButton(
                                        text: LocalStrings.removeItem.tr,
                                        icon: Icons.highlight_remove,
                                        iconSize: 20,
                                        color: ColorResources.colorRed,
                                        onTap: () {
                                          controller.decreaseItemField(index);
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
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: controller.isLoading
              ? const CustomLoader()
              : controller.isSubmitLoading
              ? const RoundedLoadingBtn()
              : Padding(
                  padding: const EdgeInsets.all(Dimensions.space10),
                  child: RoundedButton(
                    text: LocalStrings.submit.tr,
                    press: () {
                      if (formKey.currentState!.validate()) {
                        controller.submitProposal();
                      }
                    },
                  ),
                ),
        );
      },
    );
  }
}
