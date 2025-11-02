import 'package:flutex_admin/common/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/no_data.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/features/notification/controller/notification_controller.dart';
import 'package:flutex_admin/features/notification/repo/notification_repo.dart';
import 'package:flutex_admin/features/notification/widget/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(NotificationRepo(apiClient: Get.find()));
    final controller =
        Get.put(NotificationController(notificationRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(builder: (controller) {
      return Scaffold(
        appBar: CustomAppBar(
          title: LocalStrings.notification.tr,
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
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: controller.notificationsModel.data?.isNotEmpty ?? false
                      ? ListView.separated(
                          padding: const EdgeInsets.all(Dimensions.space15),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return NotificationCard(
                              notification:
                                  controller.notificationsModel.data![index],
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: Dimensions.space10),
                          itemCount: controller.notificationsModel.data!.length)
                      : const NoDataWidget(),
                ),
              ),
      );
    });
  }
}
