import 'package:flutex_admin/common/components/card/custom_card.dart';
import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/common/components/table_item.dart';
import 'package:flutex_admin/core/helper/string_format_helper.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/invoice/model/invoice_details_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoiceDetailsOverview extends StatelessWidget {
  const InvoiceDetailsOverview({super.key, required this.invoiceDetails});
  final InvoiceDetails invoiceDetails;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.space15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${invoiceDetails.prefix ?? ''}${invoiceDetails.number ?? ''}',
                  style: mediumLarge,
                ),
                Text(
                  Converter.invoiceStatusString(invoiceDetails.status ?? ''),
                  style: lightDefault.copyWith(
                    color: ColorResources.invoiceStatusColor(
                      invoiceDetails.status ?? '',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimensions.space10),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(LocalStrings.company.tr, style: lightSmall),
                      Text(LocalStrings.project.tr, style: lightSmall),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        invoiceDetails.clientData?.company ?? '',
                        style: regularDefault,
                      ),
                      Text(
                        invoiceDetails.projectData?.name ?? '-',
                        style: regularDefault,
                      ),
                    ],
                  ),
                  const CustomDivider(space: Dimensions.space10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(LocalStrings.invoiceDate.tr, style: lightSmall),
                      Text(LocalStrings.dueDate.tr, style: lightSmall),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(invoiceDetails.date ?? '', style: regularDefault),
                      Text(
                        invoiceDetails.duedate ?? '-',
                        style: regularDefault,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.space10),
              child: Text(
                LocalStrings.items.tr,
                style: mediumLarge.copyWith(
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
            CustomCard(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: Dimensions.space5),
                itemBuilder: (context, index) {
                  return TableItem(
                    item: invoiceDetails.items![index],
                    currency: invoiceDetails.currencySymbol,
                  );
                },
                separatorBuilder: (context, index) =>
                    const CustomDivider(space: Dimensions.space10),
                itemCount: invoiceDetails.items!.length,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Dimensions.space10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(LocalStrings.subtotal.tr, style: lightDefault),
                      Text(
                        '${invoiceDetails.currencySymbol ?? ''}${invoiceDetails.subtotal ?? ''}',
                        style: regularDefault,
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.space10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(LocalStrings.discount.tr, style: lightDefault),
                      Text(
                        invoiceDetails.discountTotal ?? '',
                        style: regularDefault,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: Dimensions.space10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(LocalStrings.tax.tr, style: lightDefault),
                        Text(
                          invoiceDetails.totalTax ?? '',
                          style: regularDefault,
                        ),
                      ],
                    ),
                  ),
                  if (invoiceDetails.payments?.isNotEmpty ?? false)
                    Padding(
                      padding: const EdgeInsets.only(top: Dimensions.space10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(LocalStrings.totalPaid.tr, style: lightDefault),
                          Text(
                            '- ${invoiceDetails.currencySymbol ?? ''}${(double.parse(invoiceDetails.total ?? '') - double.parse(invoiceDetails.totalLeftToPay ?? '')).toStringAsFixed(2)}',
                            style: regularDefault,
                          ),
                        ],
                      ),
                    ),
                  const CustomDivider(space: Dimensions.space10),
                  invoiceDetails.payments?.isNotEmpty ?? false
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocalStrings.amountDue.tr,
                              style: regularDefault.copyWith(
                                color: ColorResources.redColor,
                              ),
                            ),
                            Text(
                              '${invoiceDetails.currencySymbol ?? ''}${invoiceDetails.totalLeftToPay ?? ''}',
                              style: mediumDefault.copyWith(
                                color: ColorResources.redColor,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocalStrings.total.tr,
                              style: regularLarge.copyWith(
                                color: ColorResources.redColor,
                              ),
                            ),
                            Text(
                              '${invoiceDetails.currencySymbol ?? ''}${invoiceDetails.total ?? ''}',
                              style: mediumLarge.copyWith(
                                color: ColorResources.redColor,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.space10),
            if (invoiceDetails.clientNote != '')
              CustomCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocalStrings.clientNote.tr,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Divider(
                      color: ColorResources.blueGreyColor,
                      thickness: 0.50,
                    ),
                    Text(invoiceDetails.clientNote ?? '-', style: lightSmall),
                  ],
                ),
              ),
            const SizedBox(height: Dimensions.space10),
            if (invoiceDetails.adminNote != '')
              CustomCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocalStrings.adminNote.tr,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Divider(
                      color: ColorResources.blueGreyColor,
                      thickness: 0.50,
                    ),
                    Text(invoiceDetails.adminNote ?? '-', style: lightSmall),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
