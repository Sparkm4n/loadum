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
import 'package:flutex_admin/features/proposal/controller/proposal_controller.dart';
import 'package:flutex_admin/features/proposal/repo/proposal_repo.dart';
import 'package:flutex_admin/features/proposal/widget/proposal_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class ProposalScreen extends StatefulWidget {
  const ProposalScreen({super.key});

  @override
  State<ProposalScreen> createState() => _ProposalScreenState();
}

class _ProposalScreenState extends State<ProposalScreen> {
  bool showFab = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // DI
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient(sharedPreferences: Get.find()));
    }
    if (!Get.isRegistered<ProposalRepo>()) {
      Get.put(ProposalRepo(apiClient: Get.find()));
    }
    final controller = Get.put(ProposalController(proposalRepo: Get.find()));
    controller.isLoading = true;

    // FAB ein-/ausblenden beim Scrollen
    _scrollController.addListener(() {
      final dir = _scrollController.position.userScrollDirection;
      if (dir == ScrollDirection.reverse && showFab) {
        setState(() => showFab = false);
      } else if (dir == ScrollDirection.forward && !showFab) {
        setState(() => showFab = true);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initialData();
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<ProposalController>(builder: (controller) {
      final overview = controller.proposalsModel.overview ?? const [];
      final items = controller.proposalsModel.data ?? const [];

      return Scaffold(
        appBar: CustomAppBar(
          title: LocalStrings.proposals.tr,
          isShowActionBtn: true,
          actionWidget: IconButton(
            // KEINE LocalStrings.search/close mehr
            tooltip: controller.isSearch ? 'Close' : 'Search',
            onPressed: controller.changeSearchIcon,
            icon: Icon(controller.isSearch ? Icons.close_rounded : Icons.search_rounded),
          ),
        ),


        floatingActionButton: AnimatedSlide(
          offset: showFab ? Offset.zero : const Offset(0, 2),
          duration: const Duration(milliseconds: 250),
          child: AnimatedOpacity(
            opacity: showFab ? 1 : 0,
            duration: const Duration(milliseconds: 250),
            child: CustomFAB(
              isShowIcon: true,
              isShowText: false,
              press: () => Get.toNamed(RouteHelper.addProposalScreen),
            ),
          ),
        ),

        body: controller.isLoading
            ? const CustomLoader()
            : RefreshIndicator(
          color: theme.primaryColor,
          backgroundColor: theme.cardColor,
          onRefresh: () async => controller.initialData(shouldLoad: false),
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Suche
                if (controller.isSearch)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        Dimensions.space15, Dimensions.space10, Dimensions.space15, 0),
                    child: SearchField(
                      title: LocalStrings.proposalDetails.tr,
                      searchController: controller.searchController,
                      onTap: controller.searchProposal,
                    ),
                  ),

                // Overview / KPIs
                if (overview.isNotEmpty)
                  ExpansionTile(
                    initiallyExpanded: true,
                    shape: const Border(),
                    title: Row(
                      children: [
                        Container(width: 3, height: 16, color: theme.colorScheme.primary),
                        const SizedBox(width: 6),
                        Text(LocalStrings.proposalSummery.tr,
                            style: theme.textTheme.bodyLarge),
                      ],
                    ),
                    children: [
                      SizedBox(
                        height: 86,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.space15),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final item = overview[index];
                            final name = (item.status ?? '').tr;
                            final total = (item.total ?? 0).toString();
                            return OverviewCard(
                              name: name,
                              number: total,
                              color: ColorResources.blueColor,
                            );
                          },
                          separatorBuilder: (_, __) =>
                          const SizedBox(width: Dimensions.space10),
                          itemCount: overview.length,
                        ),
                      ),
                    ],
                  ),

                // Titelzeile
                Padding(
                  padding: const EdgeInsets.all(Dimensions.space15),
                  child: Row(
                    children: [
                      Text(LocalStrings.proposals.tr,
                          style: theme.textTheme.bodyLarge),
                      const Spacer(),
                      InkWell(
                        onTap: () {}, // TODO: Filter öffnen
                        child: Row(
                          children: [
                            const Icon(Icons.sort_outlined,
                                size: Dimensions.space20,
                                color: ColorResources.blueGreyColor),
                            const SizedBox(width: Dimensions.space5),
                            Text(
                              LocalStrings.filter.tr,
                              style: const TextStyle(
                                fontSize: Dimensions.fontDefault,
                                color: ColorResources.blueGreyColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Liste / Empty State
                if (items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.space15),
                    child: NoDataWidget(),
                  )
                else
                  ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.space15),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: Dimensions.space10),
                    itemBuilder: (_, index) => ProposalCard(
                      index: index,
                      proposalModel: controller.proposalsModel,
                    ),
                  ),
                const SizedBox(height: Dimensions.space15),
              ],
            ),
          ),
        ),
      );
    });
  }
}
