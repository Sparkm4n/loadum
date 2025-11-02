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
import 'package:flutex_admin/features/task/controller/task_controller.dart';
import 'package:flutex_admin/features/task/repo/task_repo.dart';
import 'package:flutex_admin/features/task/widget/task_attachment.dart';
import 'package:flutex_admin/features/task/widget/task_comment.dart';
import 'package:flutex_admin/features/task/widget/task_information.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key, required this.id});
  final String id;

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(TaskRepo(apiClient: Get.find()));
    final controller = Get.put(TaskController(taskRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadTaskDetails(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.taskDetails.tr,
        isShowActionBtn: true,
        isShowActionBtnTwo: true,
        actionWidget: IconButton(
          onPressed: () {
            Get.toNamed(RouteHelper.updateTaskScreen, arguments: widget.id);
          },
          icon: const Icon(
            Icons.edit,
            size: 20,
          ),
        ),
        actionWidgetTwo: IconButton(
          onPressed: () {
            const WarningAlertDialog().warningAlertDialog(context, () {
              Get.back();
              Get.find<TaskController>().deleteTask(widget.id);
              Navigator.pop(context);
            },
                title: LocalStrings.deleteTask.tr,
                subTitle: LocalStrings.deleteTaskWarningMSg.tr,
                image: MyImages.exclamationImage);
          },
          icon: const Icon(
            Icons.delete,
            size: 20,
          ),
        ),
      ),
      body: GetBuilder<TaskController>(
        builder: (controller) {
          return controller.isLoading
              ? const CustomLoader()
              : RefreshIndicator(
                  onRefresh: () async {
                    await controller.loadTaskDetails(widget.id);
                  },
                  child: ContainedTabBarView(
                    tabBarProperties: TabBarProperties(
                        indicatorSize: TabBarIndicatorSize.tab,
                        unselectedLabelColor: ColorResources.blueGreyColor,
                        labelColor:
                            Theme.of(context).textTheme.bodyLarge!.color,
                        labelStyle: regularDefault,
                        indicatorColor: ColorResources.secondaryColor,
                        labelPadding: const EdgeInsets.symmetric(
                            vertical: Dimensions.space15)),
                    tabs: [
                      Text(
                        LocalStrings.taskDetails.tr,
                      ),
                      Text(
                        LocalStrings.comments.tr,
                      ),
                      Text(
                        LocalStrings.attachments.tr,
                      ),
                    ],
                    views: [
                      TaskInformation(
                        taskModel: controller.taskDetailsModel.data!,
                      ),
                      TaskComments(
                        taskModel: controller.taskDetailsModel.data!,
                      ),
                      TaskAttachments(
                        taskModel: controller.taskDetailsModel.data!,
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
