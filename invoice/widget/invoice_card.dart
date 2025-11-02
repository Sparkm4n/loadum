import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/common/components/text/text_icon.dart';
import 'package:flutex_admin/core/helper/string_format_helper.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/invoice/model/invoice_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({
    super.key,
    required this.index,
    required this.invoiceModel,
  });
  final int index;
  final InvoicesModel invoiceModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(RouteHelper.invoiceDetailsScreen,
            arguments: invoiceModel.data![index].id!);
      },
      child: Card(
        margin: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                left: BorderSide(
                  width: 5.0,
                  color: ColorResources.invoiceStatusColor(
                      invoiceModel.data![index].status ?? ''),
                ),
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.all(Dimensions.space15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${invoiceModel.data![index].prefix!}${invoiceModel.data![index].number}',
                          style: regularLarge,
                        ),
                        Text(
                          '${invoiceModel.data![index].currencySymbol}${invoiceModel.data![index].total}',
                          style: regularLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.space5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          Converter.invoiceStatusString(
                              invoiceModel.data![index].status ?? ''),
                          style: lightDefault.copyWith(
                              color: ColorResources.invoiceStatusColor(
                                  invoiceModel.data![index].status ?? '')),
                        ),
                      ],
                    ),
                    const CustomDivider(space: Dimensions.space10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextIcon(
                          text: invoiceModel.data![index].clientName ?? '',
                          icon: Icons.business_center_outlined,
                        ),
                        TextIcon(
                          text: invoiceModel.data![index].date ?? '',
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
