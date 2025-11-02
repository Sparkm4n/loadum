import 'package:async/async.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutex_admin/common/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/common/components/buttons/rounded_button.dart';
import 'package:flutex_admin/common/components/buttons/rounded_loading_button.dart';
import 'package:flutex_admin/common/components/custom_drop_down_button_with_text_field.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_drop_down_text_field.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_multi_drop_down_text_field.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_text_field.dart';
import 'package:flutex_admin/common/models/countries_model.dart';
import 'package:flutex_admin/common/models/currencies_model.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/customer/controller/customer_controller.dart';
import 'package:flutex_admin/features/customer/model/groups_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final AsyncMemoizer<GroupsModel> customerGroupsMemoizer = AsyncMemoizer();
  final AsyncMemoizer<CurrenciesModel> currenciesMemoizer = AsyncMemoizer();
  final AsyncMemoizer<CountriesModel> countriesMemoizer = AsyncMemoizer();

  @override
  void dispose() {
    Get.find<CustomerController>().clearCustomerData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: LocalStrings.addCustomer.tr),
      body: GetBuilder<CustomerController>(
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
              Text(LocalStrings.billingAndShipping.tr),
            ],
            views: [
              Padding(
                padding: const EdgeInsets.all(Dimensions.space10),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    spacing: Dimensions.space15,
                    children: [
                      CustomTextField(
                        labelText: LocalStrings.companyName.tr,
                        controller: controller.companyController,
                        focusNode: controller.companyFocusNode,
                        textInputType: TextInputType.text,
                        nextFocus: controller.vatFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return LocalStrings.enterCompanyName.tr;
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          return;
                        },
                      ),
                      CustomTextField(
                        labelText: LocalStrings.vatNumber.tr,
                        controller: controller.vatController,
                        focusNode: controller.vatFocusNode,
                        textInputType: TextInputType.text,
                        nextFocus: controller.phoneFocusNode,
                        onChanged: (value) {
                          return;
                        },
                      ),
                      CustomTextField(
                        labelText: LocalStrings.phone.tr,
                        controller: controller.phoneNumberController,
                        focusNode: controller.phoneNumberFocusNode,
                        textInputType: TextInputType.number,
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
                        nextFocus: controller.addressFocusNode,
                        onChanged: (value) {
                          return;
                        },
                      ),
                      CustomTextField(
                        labelText: LocalStrings.address.tr,
                        controller: controller.addressController,
                        focusNode: controller.addressFocusNode,
                        nextFocus: controller.addressFocusNode,
                        textInputType: TextInputType.text,
                        onChanged: (value) {
                          return;
                        },
                      ),
                      FutureBuilder(
                        future: customerGroupsMemoizer.runOnce(
                          controller.loadCustomerGroups,
                        ),
                        builder: (context, groupsList) {
                          if (groupsList.data?.status ?? false) {
                            return CustomMultiDropDownTextField(
                              controller: controller.groupController,
                              hintText: LocalStrings.selectGroup.tr,
                              onChanged: (options) {
                                controller.groupsList.clear();
                                for (var v in options) {
                                  controller.groupsList.add(v.toString());
                                }
                              },
                              items: controller.groupsModel.data!.map((value) {
                                return DropdownItem(
                                  label: value.name?.tr ?? '',
                                  value: value.id!,
                                );
                              }).toList(),
                            );
                          } else if (groupsList.data?.status == false) {
                            return CustomDropDownWithTextField(
                              selectedValue: LocalStrings.noGroupFound.tr,
                              list: [LocalStrings.noGroupFound.tr],
                            );
                          } else {
                            return const CustomLoader(isFullScreen: false);
                          }
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
                              onChanged: (value) {
                                controller.currencyController.text = value
                                    .toString();
                              },
                              selectedValue: controller.currencyController.text,
                              items: controller.currenciesModel.data!.map((
                                currency,
                              ) {
                                return DropdownMenuItem(
                                  value: currency.id,
                                  child: Text(
                                    currency.name?.tr ?? '',
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
                      CustomTextField(
                        labelText: LocalStrings.city.tr,
                        controller: controller.cityController,
                        focusNode: controller.cityFocusNode,
                        nextFocus: controller.stateFocusNode,
                        textInputType: TextInputType.text,
                        onChanged: (value) {
                          return;
                        },
                      ),
                      CustomTextField(
                        labelText: LocalStrings.state.tr,
                        controller: controller.stateController,
                        focusNode: controller.stateFocusNode,
                        nextFocus: controller.zipFocusNode,
                        textInputType: TextInputType.text,
                        onChanged: (value) {
                          return;
                        },
                      ),
                      CustomTextField(
                        labelText: LocalStrings.zipCode.tr,
                        controller: controller.zipController,
                        focusNode: controller.zipFocusNode,
                        nextFocus: controller.countryFocusNode,
                        textInputType: TextInputType.text,
                        onChanged: (value) {
                          return;
                        },
                      ),
                      FutureBuilder(
                        future: countriesMemoizer.runOnce(
                          controller.loadCountries,
                        ),
                        builder: (context, countriesList) {
                          if (countriesList.data?.status ?? false) {
                            return CustomDropDownTextField(
                              hintText: LocalStrings.selectCountry.tr,
                              onChanged: (value) {
                                controller.countryController.text = value
                                    .toString();
                              },
                              selectedValue: controller.countryController.text,
                              items: controller.countriesModel.data!.map((
                                country,
                              ) {
                                return DropdownMenuItem(
                                  value: country.countryId,
                                  child: Text(
                                    country.shortName?.tr ?? '',
                                    style: regularDefault.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.color,
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          } else if (countriesList.data?.status == false) {
                            return CustomDropDownWithTextField(
                              selectedValue: LocalStrings.noCountryFound.tr,
                              list: [LocalStrings.noCountryFound.tr],
                            );
                          } else {
                            return const CustomLoader(isFullScreen: false);
                          }
                        },
                      ),
                    ],
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
                      CustomTextField(
                        labelText: LocalStrings.billingStreet.tr,
                        controller: controller.billingStreetController,
                        focusNode: controller.billingStreetFocusNode,
                        textInputType: TextInputType.text,
                        nextFocus: controller.billingCityFocusNode,
                        onChanged: (value) {
                          return;
                        },
                      ),
                      CustomTextField(
                        labelText: LocalStrings.billingCity.tr,
                        controller: controller.billingCityController,
                        focusNode: controller.billingCityFocusNode,
                        textInputType: TextInputType.text,
                        nextFocus: controller.billingStateFocusNode,
                        onChanged: (value) {
                          return;
                        },
                      ),
                      CustomTextField(
                        labelText: LocalStrings.billingState.tr,
                        controller: controller.billingStateController,
                        focusNode: controller.billingStateFocusNode,
                        textInputType: TextInputType.number,
                        nextFocus: controller.billingZipFocusNode,
                        onChanged: (value) {
                          return;
                        },
                      ),
                      CustomTextField(
                        labelText: LocalStrings.billingZip.tr,
                        controller: controller.billingZipController,
                        focusNode: controller.billingZipFocusNode,
                        textInputType: TextInputType.text,
                        nextFocus: controller.billingCountryFocusNode,
                        onChanged: (value) {
                          return;
                        },
                      ),
                      FutureBuilder(
                        future: Future.delayed(const Duration(seconds: 3)),
                        builder: (context, data) {
                          return CustomDropDownTextField(
                            hintText: LocalStrings.selectBillingCountry.tr,
                            onChanged: (value) {
                              controller.billingCountryController.text = value
                                  .toString();
                            },
                            selectedValue:
                                controller.billingCountryController.text,
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
                      ),
                      CustomTextField(
                        labelText: LocalStrings.shippingStreet.tr,
                        controller: controller.shippingStreetController,
                        focusNode: controller.shippingStreetFocusNode,
                        textInputType: TextInputType.text,
                        nextFocus: controller.shippingCityFocusNode,
                        onChanged: (value) {
                          return;
                        },
                      ),
                      CustomTextField(
                        labelText: LocalStrings.shippingCity.tr,
                        controller: controller.shippingCityController,
                        focusNode: controller.shippingCityFocusNode,
                        textInputType: TextInputType.text,
                        nextFocus: controller.shippingStateFocusNode,
                        onChanged: (value) {
                          return;
                        },
                      ),
                      CustomTextField(
                        labelText: LocalStrings.shippingState.tr,
                        controller: controller.shippingStateController,
                        focusNode: controller.shippingStateFocusNode,
                        textInputType: TextInputType.number,
                        nextFocus: controller.shippingZipFocusNode,
                        onChanged: (value) {
                          return;
                        },
                      ),
                      CustomTextField(
                        labelText: LocalStrings.shippingZip.tr,
                        controller: controller.shippingZipController,
                        focusNode: controller.shippingZipFocusNode,
                        textInputType: TextInputType.text,
                        nextFocus: controller.shippingCountryFocusNode,
                        onChanged: (value) {
                          return;
                        },
                      ),
                      FutureBuilder(
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
        child: GetBuilder<CustomerController>(
          builder: (controller) {
            return controller.isSubmitLoading
                ? const RoundedLoadingBtn()
                : RoundedButton(
                    text: LocalStrings.submit.tr,
                    press: () {
                      controller.submitCustomer();
                    },
                  );
          },
        ),
      ),
    );
  }
}
