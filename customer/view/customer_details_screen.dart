import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutex_admin/common/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/dialog/warning_dialog.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/images.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/customer/controller/customer_controller.dart';
import 'package:flutex_admin/features/customer/repo/customer_repo.dart';
import 'package:flutex_admin/features/customer/widget/customer_billing.dart';
import 'package:flutex_admin/features/customer/widget/customer_contacts.dart';
import 'package:flutex_admin/features/customer/widget/customer_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerDetailsScreen extends StatefulWidget {
  const CustomerDetailsScreen({super.key, required this.id});
  final String id;

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient(sharedPreferences: Get.find()));
    }
    if (!Get.isRegistered<CustomerRepo>()) {
      Get.put(CustomerRepo(apiClient: Get.find()));
    }
    final controller =
    Get.put(CustomerController(customerRepo: Get.find()), permanent: false);
    controller.isLoading = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadCustomerDetails(widget.id);
    });
  }

  Future<void> _reload() async {
    await Get.find<CustomerController>().loadCustomerDetails(widget.id);
  }

  void _confirmDelete(BuildContext context) {
    const WarningAlertDialog().warningAlertDialog(
      context,
          () async {
        Get.back(); // close dialog
        await Get.find<CustomerController>().deleteCustomer(widget.id);
        if (mounted) {
          Get.back(); // pop details
          Get.snackbar(
            LocalStrings.deleteCustomer.tr,
            LocalStrings.deleteCustomerWarningMSg.tr,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        }
      },
      title: LocalStrings.deleteCustomer.tr,
      subTitle: LocalStrings.deleteCustomerWarningMSg.tr,
      image: MyImages.exclamationImage,
    );
  }

  Widget _tab(String text, IconData icon) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: theme.textTheme.bodyMedium?.color),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.customerDetails.tr,
        isShowActionBtn: true,
        isShowActionBtnTwo: true,

        // Action 1: Refresh
        actionWidget: IconButton(
          tooltip: 'Refresh',
          onPressed: _reload,
          icon: const Icon(Icons.refresh, size: 20),
        ),

        // Action 2: Mehr-Menü (Edit, Add Contact, Delete)
        actionWidgetTwo: PopupMenuButton<int>(
          tooltip: 'More',
          itemBuilder: (ctx) => [
            PopupMenuItem(
              value: 0,
              child: Row(
                children: const [
                  Icon(Icons.edit, size: 18),
                  SizedBox(width: 8),
                  Text('Edit customer'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 1,
              child: Row(
                children: const [
                  Icon(Icons.person_add_alt_1, size: 18),
                  SizedBox(width: 8),
                  Text('Add contact'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 2,
              child: Row(
                children: const [
                  Icon(Icons.delete_forever_rounded, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (v) {
            switch (v) {
              case 0:
                Get.toNamed(RouteHelper.updateCustomerScreen,
                    arguments: widget.id);
                break;
              case 1:
                Get.toNamed(RouteHelper.addContactScreen,
                    arguments: widget.id);
                break;
              case 2:
                _confirmDelete(context);
                break;
            }
          },
        ),
      ),

      body: GetBuilder<CustomerController>(
        builder: (c) {
          // Loading
          if (c.isLoading) {
            return const CustomLoader();
          }

          // Fehler/leer absichern
          final data = c.customerDetailsModel.data;
          if (data == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.space20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline, color: theme.colorScheme.primary),
                    const SizedBox(height: 8),
                    Text(
                      'Customer not found',
                      style: regularLarge.copyWith(
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Please try again or contact support.',
                      style:
                      lightDefault.copyWith(color: ColorResources.blueGreyColor),
                    ),
                    const SizedBox(height: Dimensions.space15),
                    OutlinedButton.icon(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Tabs
          return ContainedTabBarView(
            tabBarProperties: TabBarProperties(
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor: ColorResources.blueGreyColor,
              labelColor: theme.textTheme.bodyLarge!.color,
              labelStyle: regularDefault,
              indicatorColor: ColorResources.secondaryColor,
              labelPadding:
              const EdgeInsets.symmetric(vertical: Dimensions.space15),
            ),
            tabs: [
              _tab(LocalStrings.profile.tr, Icons.badge_outlined),
              _tab(LocalStrings.billingAndShipping.tr,
                  Icons.local_shipping_outlined),
              _tab(LocalStrings.contacts.tr, Icons.groups_2_outlined),
            ],
            views: [
              CustomerProfile(customerModel: data),
              CustomerBilling(customerModel: data),
              CustomerContacts(id: data.userId!),
            ],
          );
        },
      ),
    );
  }
}
