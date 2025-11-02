import 'package:flutex_admin/common/components/card/custom_card.dart';
import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/common/components/text/text_icon.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/expense/model/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({super.key, required this.expense});
  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteHelper.expenseDetailsScreen, arguments: expense.id!);
      },
      child: CustomCard(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.65,
                  child: Text(
                    expense.expenseName ?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: regularDefault,
                  ),
                ),
                Text(expense.amount ?? '', style: regularDefault),
              ],
            ),
            const CustomDivider(space: Dimensions.space8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextIcon(
                  text: expense.categoryName ?? '',
                  icon: Icons.category,
                ),
                TextIcon(text: expense.date ?? '', icon: Icons.calendar_month),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
