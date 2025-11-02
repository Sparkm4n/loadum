import 'package:flutex_admin/common/components/card/custom_card.dart';
import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/common/components/text/text_icon.dart';
import 'package:flutex_admin/core/helper/string_format_helper.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/dashboard/widget/custom_container.dart';
import 'package:flutex_admin/features/dashboard/widget/custom_linerprogress.dart';
import 'package:flutex_admin/features/project/model/project_details_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverviewWidget extends StatelessWidget {
  const OverviewWidget({super.key, required this.projectDetailsModel});
  final ProjectDetails projectDetailsModel;

  @override
  Widget build(BuildContext context) {
    int daysLeft = projectDetailsModel.deadline != null
        ? int.parse(
            DateTime.parse(
              projectDetailsModel.deadline!,
            ).difference(DateTime.now()).inDays.toString(),
          )
        : 0;
    return Padding(
      padding: const EdgeInsets.all(Dimensions.space15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(projectDetailsModel.name ?? '', style: mediumLarge),
              Text(
                projectDetailsModel.statusName?.tr.capitalize ?? '',
                style: mediumDefault.copyWith(
                  color: ColorResources.projectStatusColor(
                    projectDetailsModel.status ?? '',
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
                    Text(LocalStrings.customer.tr, style: lightSmall),
                    Text(LocalStrings.billingType.tr, style: lightSmall),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      projectDetailsModel.clientData?.company ?? '',
                      style: regularDefault,
                    ),
                    Text(
                      projectDetailsModel.billingType == '1'
                          ? LocalStrings.fixedRate.tr
                          : projectDetailsModel.billingType == '2'
                          ? LocalStrings.projectHours.tr
                          : LocalStrings.taskHours.tr,
                      style: regularDefault,
                    ),
                  ],
                ),
                const CustomDivider(space: Dimensions.space10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(LocalStrings.startDate.tr, style: lightSmall),
                    Text(LocalStrings.deadline.tr, style: lightSmall),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      projectDetailsModel.startDate ?? '-',
                      style: regularDefault,
                    ),
                    Text(
                      projectDetailsModel.deadline ?? '-',
                      style: regularDefault,
                    ),
                  ],
                ),
                const CustomDivider(space: Dimensions.space10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(LocalStrings.totalRate.tr, style: lightSmall),
                    Text(LocalStrings.logged.tr, style: lightSmall),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      projectDetailsModel.billingType == '1'
                          ? projectDetailsModel.projectCost ?? '-'
                          : projectDetailsModel.billingType == '2'
                          ? '${projectDetailsModel.projectRatePerHour} / ${LocalStrings.hours.tr}'
                          : projectDetailsModel.projectCost ?? '-',
                      style: regularDefault,
                    ),
                    Text(
                      projectDetailsModel.totalLoggedTime ?? '00:00',
                      style: regularDefault,
                    ),
                  ],
                ),
                const CustomDivider(space: Dimensions.space10),
                Text(LocalStrings.description.tr, style: lightSmall),
                Text(
                  Converter.parseHtmlString(
                    projectDetailsModel.description ?? '-',
                  ),
                  style: regularDefault,
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.space15),
          Container(
            height: Dimensions.space60,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.cardRadius),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: CustomLinerProgress(
              color: ColorResources.redColor,
              value: double.parse(projectDetailsModel.progress!) * .01,
              name: LocalStrings.projectProgress.tr,
              data: '${projectDetailsModel.progress!}%',
            ),
          ),
          const SizedBox(height: Dimensions.space15),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: Dimensions.space60,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.cardRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).shadowColor.withValues(alpha: 0.05),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CustomLinerProgress(
                    color: ColorResources.greenColor,
                    value:
                        projectDetailsModel.openTasks != null &&
                            projectDetailsModel.totalTasks != null &&
                            int.parse(projectDetailsModel.totalTasks!) > 0
                        ? (int.parse(projectDetailsModel.totalTasks!) -
                                  int.parse(projectDetailsModel.openTasks!)) /
                              int.parse(projectDetailsModel.totalTasks!)
                        : 0.0,
                    name: LocalStrings.openTasks.tr,
                    data:
                        '${projectDetailsModel.openTasks} / ${projectDetailsModel.totalTasks}',
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.space8),
              Expanded(
                child: Container(
                  height: Dimensions.space60,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.cardRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).shadowColor.withValues(alpha: 0.05),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CustomLinerProgress(
                    color: ColorResources.greenColor,
                    value: double.parse(daysLeft.toString()) * .01,
                    name: LocalStrings.daysLeft.tr,
                    data:
                        '${daysLeft > 0 ? daysLeft : 0}/${daysLeft > 0 ? DateTime.parse(projectDetailsModel.deadline!).difference(DateTime.parse(projectDetailsModel.startDate!)).inDays.toString() : 0}',
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.space15),
            child: TextIcon(
              text: LocalStrings.expenses.tr,
              icon: Icons.file_open_outlined,
              iconColor: ColorResources.blueGreyColor,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomContainer(
                name: LocalStrings.totalExpenses.tr,
                number: projectDetailsModel.totalExpenses != null
                    ? '\$${projectDetailsModel.totalExpenses}'
                    : '\$0.00',
                color: Theme.of(context).textTheme.bodyLarge!.color!,
              ),
              const SizedBox(width: Dimensions.space10),
              CustomContainer(
                name: LocalStrings.billableExpenses.tr,
                number: projectDetailsModel.billableExpenses != null
                    ? '\$${projectDetailsModel.billableExpenses}'
                    : '\$0.00',
                color: ColorResources.colorOrange,
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomContainer(
                name: LocalStrings.billedExpenses.tr,
                number: projectDetailsModel.billedExpenses != null
                    ? '\$${projectDetailsModel.billedExpenses}'
                    : '\$0.00',
                color: ColorResources.greenColor,
              ),
              const SizedBox(width: Dimensions.space10),
              CustomContainer(
                name: LocalStrings.unbilledExpenses.tr,
                number: projectDetailsModel.unbilledExpenses != null
                    ? '\$${projectDetailsModel.unbilledExpenses}'
                    : '\$0.00',
                color: ColorResources.redColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
