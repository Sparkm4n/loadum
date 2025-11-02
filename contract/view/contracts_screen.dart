import 'package:flutex_admin/common/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/common/components/custom_fab.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/no_data.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/contract/controller/contract_controller.dart';
import 'package:flutex_admin/features/contract/repo/contract_repo.dart';
import 'package:flutex_admin/features/contract/widget/contract_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class ContractsScreen extends StatefulWidget {
  const ContractsScreen({super.key});

  @override
  State<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ContractRepo(apiClient: Get.find()));
    final controller = Get.put(ContractController(contractRepo: Get.find()));
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
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.contracts.tr,
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
                Get.toNamed(RouteHelper.addContractScreen);
              }),
        ),
      ),
      body: GetBuilder<ContractController>(
        builder: (controller) {
          return controller.isLoading
              ? const CustomLoader()
              : RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).cardColor,
                  onRefresh: () async {
                    await controller.initialData(shouldLoad: false);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(Dimensions.space15),
                          child: Row(
                            children: [
                              Text(
                                LocalStrings.contracts.tr,
                                style: regularLarge.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {},
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.sort_outlined,
                                      size: Dimensions.space15,
                                      color: ColorResources.blueGreyColor,
                                    ),
                                    const SizedBox(width: Dimensions.space5),
                                    Text(
                                      LocalStrings.filter.tr,
                                      style: lightSmall.copyWith(
                                          color: ColorResources.blueGreyColor),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        controller.contractsModel.data?.isNotEmpty ?? false
                            ? ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.space15),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                controller: scrollController,
                                itemBuilder: (context, index) {
                                  return ContractCard(
                                      index: index,
                                      contractModel: controller.contractsModel);
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      height: Dimensions.space10,
                                    ),
                                itemCount:
                                    controller.contractsModel.data!.length)
                            : const NoDataWidget(),
                      ],
                    ),
                  ));
        },
      ),
    );
  }
}
