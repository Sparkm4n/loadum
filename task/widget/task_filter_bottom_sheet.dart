import 'package:flutex_admin/common/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:flutex_admin/common/components/buttons/rounded_button.dart';
import 'package:flutex_admin/common/components/buttons/rounded_loading_button.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_drop_down_text_field.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/task/controller/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskFilterBottomSheet extends StatefulWidget {
  const TaskFilterBottomSheet({super.key});

  @override
  State<TaskFilterBottomSheet> createState() => _TaskFilterBottomSheetState();
}

class _TaskFilterBottomSheetState extends State<TaskFilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Dimensions.space10,
          children: [
            BottomSheetHeaderRow(
              header: LocalStrings.filter.tr,
              bottomSpace: 0,
            ),
            CustomDropDownTextField(
              needLabel: true,
              labelText: LocalStrings.priority.tr,
              hintText: LocalStrings.selectPriority.tr,
              onChanged: (value) {
                controller.priority = value;
              },
              selectedValue: controller.priority,
              items: controller.taskPriority.entries
                  .map(
                    (MapEntry element) => DropdownMenuItem(
                      value: element.key,
                      child: Text(
                        element.value,
                        style: regularDefault.copyWith(
                          color: ColorResources.taskPriorityColor(
                            element.key ?? '',
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            CustomDropDownTextField(
              needLabel: true,
              labelText: LocalStrings.status.tr,
              hintText: LocalStrings.selectStatus.tr,
              onChanged: (value) {
                controller.status = value;
              },
              selectedValue: controller.status,
              items: controller.taskStatus.entries
                  .map(
                    (MapEntry element) => DropdownMenuItem(
                      value: element.key,
                      child: Text(
                        element.value,
                        style: regularDefault.copyWith(
                          color: ColorResources.taskStatusColor(
                            element.key ?? '',
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: Dimensions.space10),
            controller.isSubmitLoading
                ? const RoundedLoadingBtn()
                : Row(
                    spacing: Dimensions.space10,
                    children: [
                      RoundedButton(
                        text: LocalStrings.submit.tr,
                        width: 0.6,
                        press: () {
                          Get.back();
                          controller.initialData();
                        },
                      ),
                      RoundedButton(
                        text: LocalStrings.clear.tr,
                        width: 0.3,
                        color: ColorResources.colorRed,
                        press: () {
                          Get.back();
                          controller.priority = null;
                          controller.status = null;
                          controller.initialData();
                        },
                      ),
                    ],
                  ),
          ],
        );
      },
    );
  }
}
