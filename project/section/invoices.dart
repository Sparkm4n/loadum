import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/no_data.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/features/invoice/widget/invoice_card.dart';
import 'package:flutex_admin/features/project/controller/project_controller.dart';
import 'package:flutex_admin/features/project/repo/project_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectInvoices extends StatefulWidget {
  const ProjectInvoices({super.key, required this.id});
  final String id;

  @override
  State<ProjectInvoices> createState() => _ProjectInvoicesState();
}

class _ProjectInvoicesState extends State<ProjectInvoices> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ProjectRepo(apiClient: Get.find()));
    final controller = Get.put(ProjectController(projectRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadProjectGroup(widget.id, 'invoices');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectController>(
      builder: (controller) {
        return Scaffold(
          body: controller.isLoading
              ? const CustomLoader()
              : controller.invoicesModel.status ?? false
              ? RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).cardColor,
                  onRefresh: () async {
                    controller.loadProjectGroup(widget.id, 'invoices');
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.space15,
                    ),
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InvoiceCard(
                        index: index,
                        invoiceModel: controller.invoicesModel,
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: Dimensions.space10),
                    itemCount: controller.invoicesModel.data!.length,
                  ),
                )
              : const Center(child: NoDataWidget()),
        );
      },
    );
  }
}
