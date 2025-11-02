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
import 'package:flutex_admin/features/invoice/controller/invoice_controller.dart';
import 'package:flutex_admin/features/invoice/repo/invoice_repo.dart';
import 'package:flutex_admin/features/invoice/section/invoice_details_overview.dart';
import 'package:flutex_admin/features/invoice/section/invoice_payments.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoiceDetailsScreen extends StatefulWidget {
  const InvoiceDetailsScreen({super.key, required this.id});
  final String id;

  @override
  State<InvoiceDetailsScreen> createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(InvoiceRepo(apiClient: Get.find()));
    final controller = Get.put(InvoiceController(invoiceRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadInvoiceDetails(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.invoiceDetails.tr,
        isShowActionBtn: true,
        isShowActionBtnTwo: true,
        actionWidget: IconButton(
          onPressed: () {
            Get.toNamed(RouteHelper.updateInvoiceScreen, arguments: widget.id);
          },
          icon: const Icon(Icons.edit, size: 20),
        ),
        actionWidgetTwo: IconButton(
          onPressed: () {
            const WarningAlertDialog().warningAlertDialog(
              context,
              () {
                Get.back();
                Get.find<InvoiceController>().deleteInvoice(widget.id);
                Navigator.pop(context);
              },
              title: LocalStrings.deleteInvoice.tr,
              subTitle: LocalStrings.deleteInvoiceWarningMSg.tr,
              image: MyImages.exclamationImage,
            );
          },
          icon: const Icon(Icons.delete, size: 20),
        ),
      ),
      body: GetBuilder<InvoiceController>(
        builder: (controller) {
          return controller.isLoading
              ? const CustomLoader()
              : RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).cardColor,
                  onRefresh: () async {
                    await controller.loadInvoiceDetails(widget.id);
                  },
                  child: ContainedTabBarView(
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
                      Text(LocalStrings.invoice.tr),
                      Text(LocalStrings.payments.tr),
                    ],
                    views: [
                      InvoiceDetailsOverview(
                        invoiceDetails: controller.invoiceDetailsModel.data!,
                      ),
                      InvoicePayments(
                        invoiceId: controller.invoiceDetailsModel.data!.id!,
                        paymentsModel:
                            controller.invoiceDetailsModel.data!.payments!,
                        currency:
                            controller
                                .invoiceDetailsModel
                                .data!
                                .currencySymbol ??
                            '-',
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
