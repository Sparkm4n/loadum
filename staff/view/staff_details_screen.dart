import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutex_admin/common/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/common/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/staff/controller/staff_controller.dart';
import 'package:flutex_admin/features/staff/repo/staff_repo.dart';
import 'package:flutex_admin/features/staff/widget/assign_staff_bottom_sheet.dart';
import 'package:flutex_admin/features/staff/widget/staff_permission.dart';
import 'package:flutex_admin/features/staff/widget/staff_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffDetailsScreen extends StatefulWidget {
  const StaffDetailsScreen({super.key, required this.id});
  final String id;

  @override
  State<StaffDetailsScreen> createState() => _StaffDetailsScreenState();
}

class _StaffDetailsScreenState extends State<StaffDetailsScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(StaffRepo(apiClient: Get.find()));
    final controller = Get.put(StaffController(staffRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadStaffDetails(widget.id);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StaffController>(
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppBar(
            title: LocalStrings.staffDetails.tr,
            isShowActionBtn: !controller.isLoading,
            actionWidget: controller.staffDetailsModel.data?.admin != '1'
                ? IconButton(
                    onPressed: () => CustomBottomSheet(
                      child: AssignStaffBottomSheet(),
                    ).customBottomSheet(context),
                    icon: const Icon(Icons.delete, size: 20),
                  )
                : SizedBox.shrink(),
          ),
          body: controller.isLoading
              ? const CustomLoader()
              : ContainedTabBarView(
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
                    Text(LocalStrings.profile.tr),
                    Text(LocalStrings.permissons.tr),
                  ],
                  views: [
                    StaffProfile(
                      staffModel: controller.staffDetailsModel.data!,
                    ),
                    StaffPermission(
                      staffModel: controller.staffDetailsModel.data!,
                    ),
                  ],
                ),
        );
      },
    );
  }
}
