import 'package:date_field/date_field.dart';
import 'package:flutex_admin/common/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:flutex_admin/common/components/buttons/rounded_button.dart';
import 'package:flutex_admin/common/components/buttons/rounded_loading_button.dart';
import 'package:flutex_admin/common/components/custom_date_form_field.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_text_field.dart';
import 'package:flutex_admin/core/helper/date_converter.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/lead/controller/lead_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNoteBottomSheet extends StatefulWidget {
  final String leadId;
  const AddNoteBottomSheet({super.key, required this.leadId});

  @override
  State<AddNoteBottomSheet> createState() => _AddNoteBottomSheetState();
}

class _AddNoteBottomSheetState extends State<AddNoteBottomSheet> {
  @override
  void dispose() {
    Get.find<LeadDetailsController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LeadDetailsController>(builder: (controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Dimensions.space10,
        children: [
          BottomSheetHeaderRow(
            header: LocalStrings.addLeadNote.tr,
            bottomSpace: 0,
          ),
          CustomTextField(
            labelText: LocalStrings.note.tr,
            controller: controller.noteController,
            focusNode: controller.noteFocusNode,
            textInputType: TextInputType.multiline,
            maxLines: 3,
            validator: (value) {
              if (value!.isEmpty) {
                return LocalStrings.enterDescription.tr;
              } else {
                return null;
              }
            },
            onChanged: (value) {
              return;
            },
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              LocalStrings.leadContacted.tr,
              style: regularDefault.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
            activeColor: ColorResources.primaryColor,
            checkColor: ColorResources.colorWhite,
            value: controller.leadContacted,
            side: WidgetStateBorderSide.resolveWith(
              (states) => BorderSide(
                  width: 1.0,
                  color: controller.leadContacted
                      ? ColorResources.getTextFieldEnableBorder()
                      : ColorResources.getTextFieldDisableBorder()),
            ),
            onChanged: (value) {
              controller.changeLeadContacted();
            },
          ),
          Visibility(
            visible: controller.leadContacted,
            child: CustomDateFormField(
              labelText: LocalStrings.dateContacted.tr,
              mode: DateTimeFieldPickerMode.dateAndTime,
              onChanged: (DateTime? value) {
                controller.dateContactedController.text =
                    DateConverter.localDateToIsoString(value!);
              },
            ),
          ),
          const SizedBox(height: Dimensions.space10),
          controller.isSubmitLoading
              ? const RoundedLoadingBtn()
              : RoundedButton(
                  text: LocalStrings.submit.tr,
                  press: () {
                    controller.addLeadNote(widget.leadId);
                  },
                ),
        ],
      );
    });
  }
}
