import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/common/components/text/text_icon.dart';
import 'package:flutex_admin/core/helper/date_converter.dart';
import 'package:flutex_admin/core/helper/string_format_helper.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/task/model/task_details_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskInformation extends StatelessWidget {
  const TaskInformation({
    super.key,
    required this.taskModel,
  });
  final TaskDetails taskModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.space10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(Dimensions.space15),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(Dimensions.cardRadius),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width / 1.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            taskModel.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            taskModel.projectData?.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: lightSmall.copyWith(
                                color: ColorResources.blueGreyColor),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                            Converter.taskPriorityString(
                                taskModel.priority ?? ''),
                            style: regularDefault.copyWith(
                              color: ColorResources.taskStatusColor(
                                  taskModel.priority ?? ''),
                            )),
                        Text(
                          taskModel.relType?.capitalizeFirst ?? '-',
                          style: lightSmall,
                        ),
                      ],
                    ),
                  ],
                ),
                const CustomDivider(space: Dimensions.space10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextIcon(
                      text: Converter.taskStatusString(taskModel.status ?? ''),
                      icon: Icons.check_circle_outline_rounded,
                    ),
                    TextIcon(
                      text: DateConverter.formatValidityDate(
                          taskModel.dateAdded ?? ''),
                      icon: Icons.calendar_month,
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: Dimensions.space20),
          Container(
            padding: const EdgeInsets.all(Dimensions.space15),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(Dimensions.cardRadius),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LocalStrings.description.tr, style: lightDefault),
                Text(Converter.parseHtmlString(taskModel.description ?? '-')),
                const CustomDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(LocalStrings.hourlyRate.tr, style: lightDefault),
                    Text(LocalStrings.billable.tr, style: lightDefault),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(taskModel.hourlyRate ?? ''),
                    Text(taskModel.billable == '1'
                        ? LocalStrings.billable.tr
                        : LocalStrings.notBillable.tr),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.space20),
          Container(
            padding: const EdgeInsets.all(Dimensions.space15),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(Dimensions.cardRadius),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(LocalStrings.checklistItems.tr),
                  ],
                ),
                const CustomDivider(space: Dimensions.space10),
                taskModel.checklistItems!.isNotEmpty
                    ? ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            title: Text(
                              taskModel.checklistItems![index].description ??
                                  '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            value: taskModel.checklistItems![index].finished ==
                                '1',
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: ColorResources.secondaryColor,
                            checkboxShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            onChanged: (bool? value) {},
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: Dimensions.space10),
                        itemCount: taskModel.checklistItems!.length)
                    : Text(LocalStrings.checklistNotFound.tr,
                        textAlign: TextAlign.center, style: lightSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
