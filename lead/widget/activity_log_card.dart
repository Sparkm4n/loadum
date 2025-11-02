import 'package:flutex_admin/common/components/card/custom_card.dart';
import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/core/helper/string_format_helper.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/lead/model/activity_log_model.dart';
import 'package:flutter/material.dart';

class ActivityLogCard extends StatelessWidget {
  const ActivityLogCard({
    super.key,
    required this.index,
    required this.activityLog,
  });
  final int index;
  final List<ActivityLog> activityLog;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${LocalStrings.date}: ${activityLog[index].date}',
            style: lightSmall.copyWith(
                color: Theme.of(context).textTheme.bodyMedium!.color),
          ),
          const CustomDivider(space: Dimensions.space10),
          Flexible(
            child: Text(
              activityLog[index].staffId != '0'
                  ? '${activityLog[index].fullName} - ${Converter.parseHtmlString(activityLog[index].additionalData ?? '')}'
                  : Converter.parseHtmlString(
                      activityLog[index].additionalData ?? ''),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: regularSmall.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
          ),
        ],
      ),
    );
  }
}
