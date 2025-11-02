import 'package:async/async.dart';
import 'package:date_field/date_field.dart';
import 'package:flutex_admin/common/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:flutex_admin/common/components/buttons/rounded_button.dart';
import 'package:flutex_admin/common/components/buttons/rounded_loading_button.dart';
import 'package:flutex_admin/common/components/custom_date_form_field.dart';
import 'package:flutex_admin/common/components/custom_drop_down_button_with_text_field.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_drop_down_text_field.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_text_field.dart';
import 'package:flutex_admin/core/helper/date_converter.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/lead/controller/lead_details_controller.dart';
import 'package:flutex_admin/features/staff/model/staff_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddReminderBottomSheet extends StatefulWidget {
  final String leadId;
  const AddReminderBottomSheet({super.key, required this.leadId});

  @override
  State<AddReminderBottomSheet> createState() => _AddReminderBottomSheetState();
}

class _AddReminderBottomSheetState extends State<AddReminderBottomSheet> {
  final AsyncMemoizer<StaffsModel> assigneeMemoizer = AsyncMemoizer();

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
        spacing: Dimensions.space15,
        children: [
          BottomSheetHeaderRow(
            header: LocalStrings.setLeadReminder.tr,
            bottomSpace: 0,
          ),
          CustomDateFormField(
            labelText: LocalStrings.dateToBeNotified.tr,
            mode: DateTimeFieldPickerMode.dateAndTime,
            onChanged: (DateTime? value) {
              controller.dateController.text =
                  DateConverter.localDateToIsoString(value!);
            },
          ),
          FutureBuilder(
              future: assigneeMemoizer.runOnce(controller.loadStaff),
              builder: (context, staffList) {
                if (staffList.data?.status ?? false) {
                  return CustomDropDownTextField(
                    hintText: LocalStrings.selectStaff.tr,
                    onChanged: (value) {
                      controller.staffController.text = value.toString();
                    },
                    items: controller.staffsModel.data!.map((value) {
                      return DropdownMenuItem(
                        value: value.id,
                        child: Text(
                          value.fullName ?? '-',
                          style: regularDefault.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color),
                        ),
                      );
                    }).toList(),
                  );
                } else if (staffList.data?.status == false) {
                  return CustomDropDownWithTextField(
                      selectedValue: LocalStrings.noStaffFound.tr,
                      list: [LocalStrings.noStaffFound.tr]);
                } else {
                  return const CustomLoader(isFullScreen: false);
                }
              }),
          CustomTextField(
            labelText: LocalStrings.description.tr,
            controller: controller.descriptionController,
            focusNode: controller.descriptionFocusNode,
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
                LocalStrings.sendEmailReminder.tr,
                style: regularDefault.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium!.color),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(Dimensions.defaultRadius)),
              activeColor: ColorResources.primaryColor,
              checkColor: ColorResources.colorWhite,
              value: controller.sendEmailReminder,
              side: WidgetStateBorderSide.resolveWith(
                (states) => BorderSide(
                    width: 1.0,
                    color: controller.sendEmailReminder
                        ? ColorResources.getTextFieldEnableBorder()
                        : ColorResources.getTextFieldDisableBorder()),
              ),
              onChanged: (value) {
                controller.changeEmailReminder();
              }),
          controller.isSubmitLoading
              ? const RoundedLoadingBtn()
              : RoundedButton(
                  text: LocalStrings.submit.tr,
                  press: () {
                    controller.addLeadReminder(widget.leadId);
                  },
                ),
        ],
      );
    });
  }
}
