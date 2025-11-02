import 'package:flutex_admin/common/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:flutex_admin/common/components/custom_fab.dart';
import 'package:flutex_admin/common/components/no_data.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/features/invoice/model/invoice_details_model.dart';
import 'package:flutex_admin/features/invoice/widget/invoice_payment_card.dart';
import 'package:flutex_admin/features/invoice/widget/payment_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoicePayments extends StatelessWidget {
  const InvoicePayments({
    super.key,
    required this.invoiceId,
    required this.paymentsModel,
    required this.currency,
  });
  final String invoiceId;
  final List<Payments> paymentsModel;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFAB(
        isShowIcon: true,
        isShowText: true,
        text: LocalStrings.payment.tr,
        press: () => CustomBottomSheet(
          child: PaymentBottomSheet(id: invoiceId),
        ).customBottomSheet(context),
      ),
      body: paymentsModel.isNotEmpty
          ? ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(Dimensions.space10),
              itemBuilder: (context, index) {
                return InvoicePaymentCard(
                  currency: currency,
                  payment: paymentsModel[index],
                );
              },
              separatorBuilder: (context, index) =>
                  const SizedBox(height: Dimensions.space10),
              itemCount: paymentsModel.length,
            )
          : const NoDataWidget(),
    );
  }
}
