import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/common/components/text/text_icon.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/payment/model/payment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({
    super.key,
    required this.index,
    required this.paymentModel,
  });
  final int index;
  final PaymentsModel paymentModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteHelper.paymentDetailsScreen,
            arguments: paymentModel.data![index].paymentId!);
      },
      child: Card(
        margin: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: const Border(
                left: BorderSide(
                  width: 5.0,
                  color: ColorResources.blueColor,
                ),
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width / 2,
                          child: Text(
                            '${LocalStrings.payment.tr} #${paymentModel.data![index].paymentId ?? paymentModel.data![index].id}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              paymentModel.data![index].amount ?? '',
                              style: regularDefault,
                            ),
                            Text(
                              paymentModel.data![index].active == '0'
                                  ? LocalStrings.notActive.tr
                                  : LocalStrings.active.tr,
                              style: lightSmall.copyWith(
                                  color: paymentModel.data![index].active == '0'
                                      ? ColorResources.blueColor
                                      : ColorResources.greenColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const CustomDivider(space: Dimensions.space8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextIcon(
                          text:
                              '${LocalStrings.invoice.tr} #${paymentModel.data?[index].invoiceId}',
                          icon: Icons.assignment_outlined,
                        ),
                        TextIcon(
                          text: paymentModel.data?[index].date ?? '',
                          icon: Icons.calendar_month,
                        ),
                      ],
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
