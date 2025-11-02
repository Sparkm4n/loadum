import 'package:flutex_admin/common/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/common/components/custom_fab.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/no_data.dart';
import 'package:flutex_admin/common/components/search_field.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/features/staff/controller/staff_controller.dart';
import 'package:flutex_admin/features/staff/repo/staff_repo.dart';
import 'package:flutex_admin/features/staff/widget/staffs_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class StaffsScreen extends StatefulWidget {
  const StaffsScreen({super.key});

  @override
  State<StaffsScreen> createState() => _StaffsScreenState();
}

class _StaffsScreenState extends State<StaffsScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(StaffRepo(apiClient: Get.find()));
    final controller = Get.put(StaffController(staffRepo: Get.find()));
    controller.isLoading = true;
    super.initState();
    handleScroll();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initialData();
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
    return GetBuilder<StaffController>(
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppBar(
            title: LocalStrings.staffs.tr,
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
                press: () {
                  Get.toNamed(RouteHelper.addStaffScreen);
                },
              ),
            ),
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
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: controller.isSearch,
                          child: SearchField(
                            title: LocalStrings.staffDetails.tr,
                            searchController: controller.searchController,
                            onTap: () => controller.searchStaff(),
                          ),
                        ),
                        controller.staffsModel.data?.isNotEmpty ?? false
                            ? Padding(
                                padding: const EdgeInsets.all(
                                  Dimensions.space15,
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return StaffsCard(
                                      staffModel:
                                          controller.staffsModel.data![index],
                                    );
                                  },
                                  itemCount:
                                      controller.staffsModel.data!.length,
                                ),
                              )
                            : const NoDataWidget(),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
