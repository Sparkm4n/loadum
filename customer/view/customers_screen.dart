import 'package:flutex_admin/common/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/common/components/custom_fab.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/no_data.dart';
import 'package:flutex_admin/common/components/search_field.dart';
import 'package:flutex_admin/common/components/text/text_icon.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/customer/controller/customer_controller.dart';
import 'package:flutex_admin/features/customer/repo/customer_repo.dart';
import 'package:flutex_admin/features/customer/widget/customers_card.dart';
import 'package:flutex_admin/features/dashboard/widget/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(CustomerRepo(apiClient: Get.find()));
    final controller = Get.put(CustomerController(customerRepo: Get.find()));
    controller.isLoading = true;
    super.initState();
    handleScroll();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initialData();
    });
  }

  bool showFab = true;
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  void handleScroll() async {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (showFab) setState(() => showFab = false);
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!showFab) setState(() => showFab = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerController>(
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppBar(
            title: LocalStrings.customers.tr,
            isShowActionBtn: true,
            actionWidget: IconButton(
              onPressed: () => controller.changeSearchIcon(),
              icon: Icon(controller.isSearch ? Icons.clear : Icons.search),
            ),
          ),
          floatingActionButton: AnimatedSlide(
            offset: showFab ? Offset.zero : const Offset(0, 2),
            duration: const Duration(milliseconds: 300),
            child: AnimatedOpacity(
              opacity: showFab ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: CustomFAB(
                isShowIcon: true,
                isShowText: false,
                press: () {
                  Get.toNamed(RouteHelper.addCustomerScreen);
                },
              ),
            ),
          ),
          body: controller.isLoading
              ? const CustomLoader()
              : RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).cardColor,
                  onRefresh: () async {
                    await controller.initialData(shouldLoad: false);
                  },
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: controller.isSearch,
                          child: SearchField(
                            title: LocalStrings.customerDetails.tr,
                            searchController: controller.searchController,
                            onTap: () => controller.searchCustomer(),
                          ),
                        ),
                        if (controller.customersModel.overview != null)
                          ExpansionTile(
                            title: Text(
                              LocalStrings.customerSummery,
                              style: regularLarge.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.color,
                              ),
                            ),
                            shape: const Border(),
                            initiallyExpanded: true,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.space15,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        CustomContainer(
                                          name: LocalStrings.totalCustomers.tr,
                                          number:
                                              controller
                                                  .customersModel
                                                  .overview
                                                  ?.customersTotal ??
                                              '',
                                          icon: Icons.group,
                                          color: ColorResources.blueColor,
                                        ),
                                        const SizedBox(
                                          width: Dimensions.space10,
                                        ),
                                        CustomContainer(
                                          name: LocalStrings.activeCustomers.tr,
                                          number:
                                              controller
                                                  .customersModel
                                                  .overview
                                                  ?.customersActive ??
                                              '',
                                          icon: Icons.group_add,
                                          color: ColorResources.greenColor,
                                        ),
                                        const SizedBox(
                                          width: Dimensions.space10,
                                        ),
                                        CustomContainer(
                                          name:
                                              LocalStrings.inactiveCustomers.tr,
                                          number:
                                              controller
                                                  .customersModel
                                                  .overview
                                                  ?.customersInactive ??
                                              '',
                                          icon: Icons.group_remove,
                                          color: ColorResources.redColor,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: Dimensions.space10),
                                    Row(
                                      children: [
                                        CustomContainer(
                                          name: LocalStrings.activeContacts.tr,
                                          number:
                                              controller
                                                  .customersModel
                                                  .overview
                                                  ?.contactsActive ??
                                              '',
                                          icon:
                                              Icons.add_circle_outline_outlined,
                                          color: ColorResources.greenColor,
                                        ),
                                        const SizedBox(
                                          width: Dimensions.space10,
                                        ),
                                        CustomContainer(
                                          name:
                                              LocalStrings.inactiveContacts.tr,
                                          number:
                                              controller
                                                  .customersModel
                                                  .overview
                                                  ?.contactsInactive ??
                                              '',
                                          icon: Icons
                                              .remove_circle_outline_outlined,
                                          color: ColorResources.redColor,
                                        ),
                                        const SizedBox(
                                          width: Dimensions.space10,
                                        ),
                                        CustomContainer(
                                          name:
                                              LocalStrings.lastLoginContacts.tr,
                                          number:
                                              controller
                                                  .customersModel
                                                  .overview
                                                  ?.contactsLastLogin ??
                                              '',
                                          icon: Icons.login_rounded,
                                          color: ColorResources.yellowColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        Padding(
                          padding: const EdgeInsets.all(Dimensions.space15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocalStrings.customers.tr,
                                style: regularLarge.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.color,
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: TextIcon(
                                  text: LocalStrings.filter.tr,
                                  icon: Icons.sort_outlined,
                                ),
                              ),
                            ],
                          ),
                        ),
                        controller.customersModel.data?.isNotEmpty ?? false
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.space15,
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return CustomersCard(
                                      index: index,
                                      customerModel: controller.customersModel,
                                    );
                                  },
                                  itemCount:
                                      controller.customersModel.data!.length,
                                ),
                              )
                            : const NoDataWidget(),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
