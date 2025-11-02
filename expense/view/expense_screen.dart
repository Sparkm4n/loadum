import 'package:flutex_admin/common/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/common/components/custom_fab.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/no_data.dart';
import 'package:flutex_admin/common/components/search_field.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/features/expense/controller/expense_controller.dart';
import 'package:flutex_admin/features/expense/repo/expense_repo.dart';
import 'package:flutex_admin/features/expense/widget/expense_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ExpenseRepo(apiClient: Get.find()));
    final controller = Get.put(ExpenseController(expenseRepo: Get.find()));
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
    return GetBuilder<ExpenseController>(
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppBar(
            title: LocalStrings.expenses.tr,
            isShowActionBtn: true,
            isShowActionBtnTwo: true,
            actionWidget: IconButton(
              onPressed: () => controller.changeSearchIcon(),
              icon: Icon(controller.isSearch ? Icons.clear : Icons.search),
            ),
            actionWidgetTwo: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.filter_alt_outlined),
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
                  Get.toNamed(RouteHelper.addExpenseScreen);
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
                      children: [
                        Visibility(
                          visible: controller.isSearch,
                          child: SearchField(
                            title: LocalStrings.expenseDetails.tr,
                            searchController: controller.searchController,
                            onTap: () => controller.searchExpense(),
                          ),
                        ),
                        controller.expenseModel.data?.isNotEmpty ?? false
                            ? ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.space15,
                                  vertical: Dimensions.space10,
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ExpenseCard(
                                    expense:
                                        controller.expenseModel.data![index],
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: Dimensions.space10),
                                itemCount: controller.expenseModel.data!.length,
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
