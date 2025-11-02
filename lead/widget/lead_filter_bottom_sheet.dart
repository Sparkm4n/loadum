import 'package:async/async.dart';
import 'package:flutex_admin/common/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:flutex_admin/common/components/buttons/rounded_button.dart';
import 'package:flutex_admin/common/components/buttons/rounded_loading_button.dart';
import 'package:flutex_admin/common/components/custom_drop_down_button_with_text_field.dart';
import 'package:flutex_admin/common/components/custom_loader/custom_loader.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_drop_down_text_field.dart';
import 'package:flutex_admin/core/helper/string_format_helper.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/lead/controller/lead_controller.dart';
import 'package:flutex_admin/features/lead/model/sources_model.dart';
import 'package:flutex_admin/features/lead/model/statuses_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeadFilterBottomSheet extends StatefulWidget {
  const LeadFilterBottomSheet({super.key});

  @override
  State<LeadFilterBottomSheet> createState() => _LeadFilterBottomSheetState();
}

class _LeadFilterBottomSheetState extends State<LeadFilterBottomSheet> {
  final AsyncMemoizer<SourcesModel> sourcesMemoizer = AsyncMemoizer();
  final AsyncMemoizer<StatusesModel> statusesMemoizer = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LeadController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Dimensions.space10,
          children: [
            BottomSheetHeaderRow(
              header: LocalStrings.filter.tr,
              bottomSpace: 0,
            ),
            FutureBuilder(
              future: sourcesMemoizer.runOnce(controller.loadLeadSources),
              builder: (context, sourceList) {
                if (sourceList.data?.status ?? false) {
                  return CustomDropDownTextField(
                    needLabel: true,
                    labelText: LocalStrings.source.tr,
                    hintText: LocalStrings.selectSource.tr,
                    onChanged: (value) {
                      controller.source = value.toString();
                    },
                    selectedValue: controller.source,
                    items: controller.sourcesModel.data!.map((value) {
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
                } else if (sourceList.data?.status == false) {
                  return CustomDropDownWithTextField(
                    selectedValue: LocalStrings.noSourceFound.tr,
                    list: [LocalStrings.noSourceFound.tr],
                  );
                } else {
                  return const CustomLoader(isFullScreen: false);
                }
              },
            ),
            FutureBuilder(
              future: statusesMemoizer.runOnce(controller.loadLeadStatuses),
              builder: (context, statusList) {
                if (statusList.data?.status ?? false) {
                  return CustomDropDownTextField(
                    needLabel: true,
                    labelText: LocalStrings.status.tr,
                    hintText: LocalStrings.selectStatus.tr,
                    onChanged: (value) {
                      controller.status = value.toString();
                    },
                    selectedValue: controller.status,
                    items: controller.statusesModel.data!.map((value) {
                      return DropdownMenuItem(
                        value: value.id,
                        child: Text(
                          value.name?.tr ?? '',
                          style: regularDefault.copyWith(
                            color: Converter.hexStringToColor(
                              value.color ?? '',
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else if (statusList.data?.status == false) {
                  return CustomDropDownWithTextField(
                    selectedValue: LocalStrings.noStatusFound.tr,
                    list: [LocalStrings.noStatusFound.tr],
                  );
                } else {
                  return const CustomLoader(isFullScreen: false);
                }
              },
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
                          controller.source = null;
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
