import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'package:flutex_admin/common/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/common/components/custom_fab.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/no_data.dart';
import 'package:flutex_admin/common/components/overview_card.dart';
import 'package:flutex_admin/common/components/search_field.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';

import 'package:flutex_admin/features/task/controller/task_controller.dart';
import 'package:flutex_admin/features/task/repo/task_repo.dart';
import 'package:flutex_admin/features/task/widget/task_card.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  bool showFab = true;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient(sharedPreferences: Get.find()));
    }
    if (!Get.isRegistered<TaskRepo>()) {
      Get.put(TaskRepo(apiClient: Get.find()));
    }
    final controller = Get.put(TaskController(taskRepo: Get.find()));
    controller.isLoading = true;

    _handleScroll();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initialData();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (showFab) setState(() => showFab = false);
      } else if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (!showFab) setState(() => showFab = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(builder: (controller) {
      return Scaffold(
        appBar: CustomAppBar(
          title: LocalStrings.tasks.tr,
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
              press: () => Get.toNamed(RouteHelper.addTaskScreen),
            ),
          ),
        ),
        body: controller.isLoading
            ? const CustomLoader()
            : RefreshIndicator(
          color: ColorResources.primaryColor,
          onRefresh: () async => controller.initialData(shouldLoad: false),
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Suche
                Visibility(
                  visible: controller.isSearch,
                  child: SearchField(
                    title: LocalStrings.taskDetails.tr,
                    searchController: controller.searchController,
                    onTap: controller.searchTask,
                  ),
                ),

                // Overview (Status-Chips)
                if (controller.tasksModel.overview != null)
                  ExpansionTile(
                    title: Row(
                      children: [
                        Container(width: Dimensions.space3, height: Dimensions.space15, color: Colors.blue),
                        const SizedBox(width: Dimensions.space5),
                        Text(LocalStrings.taskSummery.tr, style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                    shape: const Border(),
                    initiallyExpanded: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15),
                        child: SizedBox(
                          height: 80,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.tasksModel.overview!.length,
                            itemBuilder: (context, index) {
                              final o = controller.tasksModel.overview![index];
                              return OverviewCard(
                                name: (o.status ?? '').tr,
                                number: (o.total ?? '').toString(),
                                color: ColorResources.blueColor,
                              );
                            },
                            separatorBuilder: (_, __) => const SizedBox(width: Dimensions.space5),
                          ),
                        ),
                      ),
                    ],
                  ),

                // Header + Filter
                Padding(
                  padding: const EdgeInsets.all(Dimensions.space15),
                  child: Row(
                    children: [
                      Text(LocalStrings.tasks.tr, style: Theme.of(context).textTheme.bodyLarge),
                      const Spacer(),
                      InkWell(
                        onTap: () {}, // TODO: Filter öffnen
                        child: Row(
                          children: const [
                            Icon(Icons.sort_outlined, size: Dimensions.space20, color: ColorResources.blueGreyColor),
                            SizedBox(width: Dimensions.space5),
                            Text(
                              'Filter',
                              style: TextStyle(fontSize: Dimensions.fontDefault, color: ColorResources.blueGreyColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Liste
                (controller.tasksModel.data?.isNotEmpty ?? false)
                    ? ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15),
                  itemCount: controller.tasksModel.data!.length,
                  itemBuilder: (context, index) {
                    final task = controller.tasksModel.data![index];
                    // NEU: TaskCard erwartet jetzt required: task
                    return TaskCard(
                      task: task,
                      // Wenn TaskCard weitere optionale Parameter hat (z. B. onTap),
                      // kannst du sie hier ergänzen:
                      // onTap: () => Get.toNamed(RouteHelper.taskDetailsScreen, arguments: task.id),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: Dimensions.space10),
                )
                    : const NoDataWidget(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
