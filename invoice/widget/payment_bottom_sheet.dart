import 'package:async/async.dart';
import 'package:flutex_admin/common/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:flutex_admin/common/components/buttons/rounded_button.dart';
import 'package:flutex_admin/common/components/buttons/rounded_loading_button.dart';
import 'package:flutex_admin/common/components/custom_date_form_field.dart';
import 'package:flutex_admin/common/components/custom_drop_down_button_with_text_field.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_drop_down_text_field.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_text_field.dart';
import 'package:flutex_admin/common/models/payment_modes_model.dart';
import 'package:flutex_admin/core/helper/date_converter.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/invoice/controller/invoice_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentBottomSheet extends StatefulWidget {
  final String id;
  const PaymentBottomSheet({super.key, required this.id});

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  final AsyncMemoizer<PaymentModesModel> paymentModesMemoizer = AsyncMemoizer();

  @override
  void dispose() {
    Get.find<InvoiceController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvoiceController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Dimensions.space10,
          children: [
            BottomSheetHeaderRow(
              header: LocalStrings.recordPayment.tr,
              bottomSpace: 0,
            ),
            CustomTextField(
              labelText: LocalStrings.amountReceived.tr,
              controller: controller.amountReceivedController,
              focusNode: controller.amountReceivedFocusNode,
              textInputType: TextInputType.number,
              nextFocus: controller.dateFocusNode,
              validator: (value) {
                if (value!.isEmpty) {
                  return LocalStrings.amount.tr;
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                return;
              },
            ),
            CustomDateFormField(
              labelText: LocalStrings.date.tr,
              onChanged: (DateTime? value) {
                controller.paymentDateController.text =
                    DateConverter.formatDate(value!);
              },
            ),
            FutureBuilder(
              future: paymentModesMemoizer.runOnce(controller.loadPaymentModes),
              builder: (context, paymentModesList) {
                if (paymentModesList.data?.status ?? false) {
                  return CustomDropDownTextField(
                    hintText: LocalStrings.selectPaymentMode.tr,
                    onChanged: (value) {
                      controller.modeController.text = value.toString();
                    },
                    selectedValue: controller.modeController.text,
                    items: controller.paymentModesModel.data!.map((value) {
                      return DropdownMenuItem(
                        value: value.id,
                        child: Text(
                          value.name?.tr ?? '',
                          style: regularDefault.copyWith(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.color,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else if (paymentModesList.data?.status == false) {
                  return CustomDropDownWithTextField(
                    selectedValue: LocalStrings.noPaymentModeFound.tr,
                    list: [LocalStrings.noPaymentModeFound.tr],
                  );
                } else {
                  return const CustomLoader(isFullScreen: false);
                }
              },
            ),
            CustomTextField(
              labelText: LocalStrings.transactionId.tr,
              controller: controller.transactionIDController,
              focusNode: controller.transactionIDFocusNode,
              nextFocus: controller.noteFocusNode,
              onChanged: (value) {
                return;
              },
            ),
            CustomTextField(
              labelText: LocalStrings.note.tr,
              controller: controller.noteController,
              focusNode: controller.noteFocusNode,
              textInputType: TextInputType.text,
              maxLines: 3,
              onChanged: (value) {
                return;
              },
            ),
            const SizedBox(height: Dimensions.space10),
            controller.isSubmitLoading
                ? const RoundedLoadingBtn()
                : RoundedButton(
                    text: LocalStrings.submit.tr,
                    press: () {
                      controller.recordInvoicePayment(widget.id);
                    },
                  ),
          ],
        );
      },
    );
  }
}
