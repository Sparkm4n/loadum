import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/no_data.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/features/estimate/widget/estimate_card.dart';
import 'package:flutex_admin/features/project/controller/project_controller.dart';
import 'package:flutex_admin/features/project/repo/project_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectEstimates extends StatefulWidget {
  const ProjectEstimates({super.key, required this.id});
  final String id;

  @override
  State<ProjectEstimates> createState() => _ProjectEstimatesState();
}

class _ProjectEstimatesState extends State<ProjectEstimates> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ProjectRepo(apiClient: Get.find()));
    final controller = Get.put(ProjectController(projectRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadProjectGroup(widget.id, 'estimates');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectController>(
      builder: (controller) {
        return Scaffold(
          body: controller.isLoading
              ? const CustomLoader()
              : controller.estimatesModel.status ?? false
              ? RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).cardColor,
                  onRefresh: () async {
                    controller.loadProjectGroup(widget.id, 'estimates');
                  },
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.space15,
                    ),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return EstimateCard(
                        index: index,
                        estimateModel: controller.estimatesModel,
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: Dimensions.space10),
                    itemCount: controller.estimatesModel.data!.length,
                  ),
                )
              : const Center(child: NoDataWidget()),
        );
      },
    );
  }
}
