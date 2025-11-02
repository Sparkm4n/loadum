import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/common/components/text/text_icon.dart';
import 'package:flutex_admin/core/helper/date_converter.dart';
import 'package:flutex_admin/core/helper/string_format_helper.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/lead/model/lead_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeadCard extends StatelessWidget {
  const LeadCard({
    super.key,
    required this.index,
    required this.leadModel,
  });
  final int index;
  final LeadsModel leadModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteHelper.leadDetailsScreen,
            arguments: leadModel.data![index].id!);
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
                  color: Converter.hexStringToColor(
                      leadModel.data![index].color ?? ''),
                ),
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.all(15),
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
                                '${leadModel.data![index].name}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                '${leadModel.data![index].title} - ${leadModel.data![index].company}',
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
                              leadModel.data![index].leadValue ?? '-',
                              style: regularDefault,
                            ),
                            Text(
                              leadModel.data![index].sourceName ?? '-',
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
                          text: leadModel.data![index].statusName ?? '',
                          icon: Icons.check_circle_outline_rounded,
                          iconColor: Converter.hexStringToColor(
                              leadModel.data![index].color ?? ''),
                        ),
                        TextIcon(
                          text: DateConverter.formatValidityDate(
                              leadModel.data![index].dateAdded ?? ''),
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
