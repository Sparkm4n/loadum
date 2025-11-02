import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutex_admin/common/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/dialog/warning_dialog.dart';
import 'package:flutex_admin/common/components/text/text_icon.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/images.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/lead/controller/lead_details_controller.dart';
import 'package:flutex_admin/features/lead/repo/lead_repo.dart';
import 'package:flutex_admin/features/lead/section/lead_activity_log.dart';
import 'package:flutex_admin/features/lead/section/lead_attachment.dart';
import 'package:flutex_admin/features/lead/section/lead_notes.dart';
import 'package:flutex_admin/features/lead/section/lead_reminders.dart';
import 'package:flutex_admin/features/lead/widget/lead_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeadDetailsScreen extends StatefulWidget {
  const LeadDetailsScreen({super.key, required this.id});
  final String id;

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LeadRepo(apiClient: Get.find()));
    final controller = Get.put(LeadDetailsController(leadRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadLeadDetails(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.leadDetails.tr,
        isShowActionBtn: true,
        isShowActionBtnTwo: true,
        actionWidget: IconButton(
          onPressed: () {
            Get.toNamed(RouteHelper.updateLeadScreen, arguments: widget.id);
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
              Get.find<LeadDetailsController>().deleteLead(widget.id);
              Navigator.pop(context);
            },
                title: LocalStrings.deleteLead.tr,
                subTitle: LocalStrings.deleteLeadWarningMSg.tr,
                image: MyImages.exclamationImage);
          },
          icon: const Icon(
            Icons.delete,
            size: 20,
          ),
        ),
      ),
      body: GetBuilder<LeadDetailsController>(
        builder: (controller) {
          return controller.isLoading
              ? const CustomLoader()
              : RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).cardColor,
                  onRefresh: () async {
                    await controller.loadLeadDetails(widget.id);
                  },
                  child: ContainedTabBarView(
                    tabBarProperties: TabBarProperties(
                      isScrollable: true,
                      labelColor: Theme.of(context).textTheme.bodyLarge!.color,
                      background: Container(color: Theme.of(context).cardColor),
                      indicatorSize: TabBarIndicatorSize.tab,
                      unselectedLabelColor: ColorResources.blueGreyColor,
                      indicatorColor: ColorResources.secondaryColor,
                      labelPadding: const EdgeInsets.symmetric(
                          vertical: Dimensions.space17,
                          horizontal: Dimensions.space20),
                    ),
                    tabs: [
                      TextIcon(
                        text: LocalStrings.profile.tr,
                        textStyle: regularLarge.copyWith(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color),
                        icon: Icons.person_4_outlined,
                        iconSize: 18,
                        space: Dimensions.space10,
                      ),
                      TextIcon(
                        text: LocalStrings.attachments.tr,
                        textStyle: regularLarge.copyWith(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color),
                        icon: Icons.attach_file_outlined,
                        iconSize: 18,
                        space: Dimensions.space10,
                      ),
                      TextIcon(
                        text: LocalStrings.reminders.tr,
                        textStyle: regularLarge.copyWith(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color),
                        icon: Icons.notifications_active_outlined,
                        iconSize: 18,
                        space: Dimensions.space10,
                      ),
                      TextIcon(
                        text: LocalStrings.notes.tr,
                        textStyle: regularLarge.copyWith(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color),
                        icon: Icons.sticky_note_2_outlined,
                        iconSize: 18,
                        space: Dimensions.space10,
                      ),
                      TextIcon(
                        text: LocalStrings.activityLogs.tr,
                        textStyle: regularLarge.copyWith(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color),
                        icon: Icons.format_line_spacing_outlined,
                        iconSize: 18,
                        space: Dimensions.space10,
                      ),
                    ],
                    views: [
                      LeadProfile(
                        leadModel: controller.leadDetailsModel.data!,
                      ),
                      LeadAttachment(
                        leadModel: controller.leadDetailsModel.data!,
                      ),
                      LeadReminders(
                        id: controller.leadDetailsModel.data!.id!,
                      ),
                      LeadNotes(
                        id: controller.leadDetailsModel.data!.id!,
                      ),
                      LeadActivityLog(
                        id: controller.leadDetailsModel.data!.id!,
                      ),
                    ],
                  ));
        },
      ),
    );
  }
}
