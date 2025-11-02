import 'package:flutex_admin/common/components/app-bar/custom_appbar.dart';
import 'package:flutex_admin/common/components/card/custom_card.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/dialog/warning_dialog.dart';
import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/common/components/text/header_text.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/images.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/expense/controller/expense_controller.dart';
import 'package:flutex_admin/features/expense/repo/expense_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseDetailsScreen extends StatefulWidget {
  const ExpenseDetailsScreen({super.key, required this.id});
  final String id;

  @override
  State<ExpenseDetailsScreen> createState() => _ExpenseDetailsScreenState();
}

class _ExpenseDetailsScreenState extends State<ExpenseDetailsScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ExpenseRepo(apiClient: Get.find()));
    final controller = Get.put(ExpenseController(expenseRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadExpenseDetails(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.expenseDetails.tr,
        isShowActionBtn: true,
        isShowActionBtnTwo: true,
        actionWidget: IconButton(
          onPressed: () {
            Get.toNamed(RouteHelper.updateExpenseScreen, arguments: widget.id);
          },
          icon: const Icon(Icons.edit, size: 20),
        ),
        actionWidgetTwo: IconButton(
          onPressed: () {
            const WarningAlertDialog().warningAlertDialog(
              context,
              () {
                Get.back();
                Get.find<ExpenseController>().deleteExpense(widget.id);
                Navigator.pop(context);
              },
              title: LocalStrings.deleteExpense.tr,
              subTitle: LocalStrings.deleteExpenseWarningMSg.tr,
              image: MyImages.exclamationImage,
            );
          },
          icon: const Icon(Icons.delete, size: 20),
        ),
      ),
      body: GetBuilder<ExpenseController>(
        builder: (controller) {
          return controller.isLoading
              ? const CustomLoader()
              : RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).cardColor,
                  onRefresh: () async =>
                      await controller.loadExpenseDetails(widget.id),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: CustomCard(
                      margin: const EdgeInsets.all(Dimensions.space10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: Dimensions.space5,
                        children: [
                          HeaderText(
                            text:
                                '${controller.expenseDetailsModel.data!.expenseName}',
                            textStyle: mediumLarge,
                          ),
                          const CustomDivider(space: Dimensions.space5),
                          Text(
                            '${LocalStrings.expenseCategory.tr}:',
                            style: regularDefault,
                          ),
                          Text(
                            '${controller.expenseDetailsModel.data!.name}',
                            style: lightDefault,
                          ),
                          Text(
                            '${LocalStrings.date.tr}:',
                            style: regularDefault,
                          ),
                          Text(
                            '${controller.expenseDetailsModel.data!.date}',
                            style: lightDefault,
                          ),
                          Text(
                            '${LocalStrings.amount.tr}:',
                            style: regularDefault,
                          ),
                          Text(
                            '${controller.expenseDetailsModel.data!.currencyData?.symbol}${controller.expenseDetailsModel.data!.amount}',
                            style: lightDefault,
                          ),
                          const CustomDivider(space: Dimensions.space5),
                          Text(
                            '${LocalStrings.note.tr}:',
                            style: regularDefault,
                          ),
                          Text(
                            '${controller.expenseDetailsModel.data!.note}',
                            style: lightDefault,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
