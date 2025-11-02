import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/no_data.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/features/project/controller/project_controller.dart';
import 'package:flutex_admin/features/project/repo/project_repo.dart';
import 'package:flutex_admin/features/task/widget/task_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectTasks extends StatefulWidget {
  const ProjectTasks({super.key, required this.id});
  final String id;

  @override
  State<ProjectTasks> createState() => _ProjectTasksState();
}

class _ProjectTasksState extends State<ProjectTasks> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ProjectRepo(apiClient: Get.find()));
    final controller = Get.put(ProjectController(projectRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadProjectGroup(widget.id, 'tasks');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectController>(
      builder: (controller) {
        return Scaffold(
          body: controller.isLoading
              ? const CustomLoader()
              : controller.tasksModel.status ?? false
              ? RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).cardColor,
                  onRefresh: () async {
                    controller.loadProjectGroup(widget.id, 'tasks');
                  },
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(Dimensions.space15),
                    itemBuilder: (context, index) {
                      return TaskCard(task: controller.tasksModel.data![index]);
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: Dimensions.space10),
                    itemCount: controller.tasksModel.data!.length,
                  ),
                )
              : const Center(child: NoDataWidget()),
        );
      },
    );
  }
}
