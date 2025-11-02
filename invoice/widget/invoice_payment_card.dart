import 'package:flutex_admin/common/components/card/custom_card.dart';
import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/common/components/text/text_icon.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/invoice/model/invoice_details_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoicePaymentCard extends StatelessWidget {
  const InvoicePaymentCard({
    super.key,
    required this.payment,
    required this.currency,
  });
  final Payments payment;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${LocalStrings.payment.tr} #${payment.paymentId ?? ''}',
                style: regularDefault,
              ),
              Text('$currency${payment.amount ?? ''}', style: regularDefault),
            ],
          ),
          const SizedBox(height: Dimensions.space5),
          if (payment.transactionId?.isNotEmpty ?? false)
            Text(
              '${LocalStrings.transactionId.tr}: ${payment.transactionId ?? ''}',
              style: lightDefault.copyWith(color: ColorResources.blueGreyColor),
            ),
          const CustomDivider(space: Dimensions.space10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextIcon(
                text: payment.methodName ?? '',
                icon: Icons.payments_outlined,
              ),
              TextIcon(text: payment.date ?? '', icon: Icons.calendar_month),
            ],
          ),
        ],
      ),
    );
  }
}
