import 'package:flutex_admin/common/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:flutex_admin/common/components/custom_fab.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/no_data.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/features/lead/controller/lead_details_controller.dart';
import 'package:flutex_admin/features/lead/repo/lead_repo.dart';
import 'package:flutex_admin/features/lead/widget/add_reminder_bottom_sheet.dart';
import 'package:flutex_admin/features/lead/widget/reminder_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class LeadReminders extends StatefulWidget {
  const LeadReminders({super.key, required this.id});
  final String id;

  @override
  State<LeadReminders> createState() => _LeadRemindersState();
}

class _LeadRemindersState extends State<LeadReminders> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LeadRepo(apiClient: Get.find()));
    final controller = Get.put(LeadDetailsController(leadRepo: Get.find()));
    controller.isLoading = true;
    super.initState();
    handleScroll();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadLeadReminders(widget.id);
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
    return GetBuilder<LeadDetailsController>(
      builder: (controller) {
        return Scaffold(
          body: controller.isLoading
              ? const CustomLoader()
              : controller.remindersModel.status ?? false
              ? RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).cardColor,
                  onRefresh: () async {
                    controller.loadLeadReminders(widget.id);
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(Dimensions.space10),
                    itemBuilder: (context, index) {
                      return ReminderCard(
                        reminder: controller.remindersModel.data![index],
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: Dimensions.space10),
                    itemCount: controller.remindersModel.data!.length,
                  ),
                )
              : const Center(child: NoDataWidget()),
          floatingActionButton: AnimatedSlide(
            offset: showFab ? Offset.zero : const Offset(0, 2),
            duration: const Duration(milliseconds: 300),
            child: AnimatedOpacity(
              opacity: showFab ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: CustomFAB(
                icon: Icons.notifications_active_outlined,
                isShowText: true,
                text: LocalStrings.setLeadReminder.tr,
                press: () {
                  CustomBottomSheet(
                    child: AddReminderBottomSheet(leadId: widget.id),
                  ).customBottomSheet(context);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
