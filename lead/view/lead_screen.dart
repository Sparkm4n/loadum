import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutex_admin/common/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/common/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:flutex_admin/features/lead/widget/lead_sort_bottom_sheet.dart';
import 'package:flutex_admin/features/lead/widget/lead_filter_bottom_sheet.dart';
import 'package:flutex_admin/common/components/custom_fab.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/no_data.dart';
import 'package:flutex_admin/common/components/overview_card.dart';
import 'package:flutex_admin/common/components/search_field.dart';
import 'package:flutex_admin/common/components/text/text_icon.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/lead/controller/lead_controller.dart';
import 'package:flutex_admin/features/lead/repo/lead_repo.dart';
import 'package:flutex_admin/features/lead/widget/lead_card.dart';

class LeadScreen extends StatefulWidget {
  const LeadScreen({super.key});

  @override
  State<LeadScreen> createState() => _LeadScreenState();
}

class _LeadScreenState extends State<LeadScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LeadRepo(apiClient: Get.find()));
    final controller = Get.put(LeadController(leadRepo: Get.find()));
    controller.isLoading = true;
    controller.handleScroll();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LeadController>(
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppBar(
            title: LocalStrings.leads.tr,
            isShowActionBtn: true,
            actionWidget: IconButton(
              onPressed: () => Get.toNamed(RouteHelper.kanbanLeadScreen),
              icon: const Icon(Icons.grid_view_outlined),
            ),
            isShowActionBtnTwo: true,
            actionWidgetTwo: IconButton(
              onPressed: () => controller.changeSearchIcon(),
              icon: Icon(controller.isSearch ? Icons.clear : Icons.search),
            ),
          ),
          floatingActionButton: AnimatedSlide(
            offset: controller.showFab ? Offset.zero : const Offset(0, 2),
            duration: const Duration(milliseconds: 300),
            child: AnimatedOpacity(
              opacity: controller.showFab ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: CustomFAB(
                isShowIcon: true,
                isShowText: false,
                press: () => Get.toNamed(RouteHelper.addLeadScreen),
              ),
            ),
          ),
          body: controller.isLoading
              ? const CustomLoader()
              : RefreshIndicator(
            color: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).cardColor,
            onRefresh: () async {
              controller.initialData();
            },
            child: Column(
              children: [
                Visibility(
                  visible: controller.isSearch,
                  child: SearchField(
                    title: LocalStrings.leadDetails.tr,
                    searchController: controller.searchController,
                    onTap: () => controller.searchLead(),
                  ),
                ),

                if (controller.leadsModel.overview != null)
                  ExpansionTile(
                    title: Row(
                      children: [
                        Container(
                          width: Dimensions.space3,
                          height: Dimensions.space15,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: Dimensions.space5),
                        Text(
                          LocalStrings.leadSummery.tr,
                          style: regularLarge.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .color,
                          ),
                        ),
                      ],
                    ),
                    shape: const Border(),
                    initiallyExpanded: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.space15,
                        ),
                        child: SizedBox(
                          height: 80,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return OverviewCard(
                                name: controller
                                    .leadsModel
                                    .overview![index]
                                    .status!
                                    .tr,
                                number: controller
                                    .leadsModel
                                    .overview![index]
                                    .total
                                    .toString(),
                                color: ColorResources.blueColor,
                              );
                            },
                            separatorBuilder: (context, index) =>
                            const SizedBox(width: Dimensions.space5),
                            itemCount: controller
                                .leadsModel.overview!.length,
                          ),
                        ),
                      ),
                    ],
                  ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.space15,
                    vertical: Dimensions.space10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocalStrings.leads.tr,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Row(
                        // Falls dein Flutter keine `spacing`-Prop bei Row kennt, ersetze
                        // das durch: children: [ InkWell(...), const SizedBox(width: Dimensions.space15), InkWell(...) ]
                        spacing: Dimensions.space15,
                        children: [
                          InkWell(
                            onTap: () => CustomBottomSheet(
                              child: LeadFilterBottomSheet(),
                            ).customBottomSheet(context),
                            child: TextIcon(
                              text: LocalStrings.filter.tr,
                              icon: Icons.filter_alt,
                            ),
                          ),
                          InkWell(
                            onTap: () => CustomBottomSheet(
                              child: LeadSortBottomSheet(),
                            ).customBottomSheet(context),
                            child: TextIcon(
                              text: LocalStrings.sortBy.tr,
                              icon: Icons.sort,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // === Liste der Leads
                (controller.leadsModel.data?.isNotEmpty ?? false)
                    ? Flexible(
                  child: Obx(
                        () => ListView.separated(
                      controller: controller.scrollController,
                      padding: const EdgeInsets.fromLTRB(
                        Dimensions.space15,
                        0,
                        Dimensions.space15,
                        Dimensions.space15,
                      ),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final total =
                            controller.leadsModel.data?.length ?? 0;
                        final isLastItem = index == total - 1;

                        if (isLastItem && controller.hasMoreData) {
                          return Column(
                            children: [
                              LeadCard(
                                index: index,
                                leadModel:
                                controller.leadsModel,
                              ),
                              const SizedBox(
                                  height: Dimensions.space10),
                              const CustomLoader(
                                isFullScreen: false,
                                isPagination: true,
                              ),
                            ],
                          );
                        }

                        return LeadCard(
                          index: index,
                          leadModel: controller.leadsModel,
                        );
                      },
                      // <- WICHTIG: separatorBuilder ist bei ListView.separated Pflicht
                      separatorBuilder: (context, index) =>
                      const SizedBox(
                          height: Dimensions.space10),
                      itemCount: controller
                          .leadsModel.data?.length ??
                          0,
                    ),
                  ),
                )
                    : const NoDataWidget(),
              ],
            ),
          ),
        );
      },
    );
  }
}
