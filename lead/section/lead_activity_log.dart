import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/no_data.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/features/lead/controller/lead_details_controller.dart';
import 'package:flutex_admin/features/lead/repo/lead_repo.dart';
import 'package:flutex_admin/features/lead/widget/activity_log_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelines_plus/timelines_plus.dart';

class LeadActivityLog extends StatefulWidget {
  const LeadActivityLog({super.key, required this.id});
  final String id;

  @override
  State<LeadActivityLog> createState() => _LeadActivityLogState();
}

class _LeadActivityLogState extends State<LeadActivityLog> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LeadRepo(apiClient: Get.find()));
    final controller = Get.put(LeadDetailsController(leadRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadLeadActivityLog(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LeadDetailsController>(
      builder: (controller) {
        return Scaffold(
          body: controller.isLoading
              ? const CustomLoader()
              : controller.activityLogModel.status ?? false
              ? RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).cardColor,
                  onRefresh: () async {
                    controller.loadLeadActivityLog(widget.id);
                  },
                  child: Timeline.tileBuilder(
                    theme: TimelineThemeData(
                      nodePosition: 0,
                      connectorTheme: const ConnectorThemeData(
                        thickness: 3.0,
                        color: Color(0xffd3d3d3),
                      ),
                      indicatorTheme: const IndicatorThemeData(size: 15.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.space20,
                    ),
                    builder: TimelineTileBuilder.connected(
                      contentsBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.space10,
                          horizontal: Dimensions.space10,
                        ),
                        child: ActivityLogCard(
                          index: index,
                          activityLog: controller.activityLogModel.data!,
                        ),
                      ),
                      connectorBuilder: (_, index, __) =>
                          const SolidLineConnector(),
                      indicatorBuilder: (_, index) =>
                          const OutlinedDotIndicator(
                            color: Color(0xffbabdc0),
                            backgroundColor: Color(0xffe6e7e9),
                          ),
                      itemCount: controller.activityLogModel.data!.length,
                    ),
                  ),
                )
              : const Center(child: NoDataWidget()),
        );
      },
    );
  }
}
