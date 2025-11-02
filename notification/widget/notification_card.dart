import 'package:flutex_admin/common/components/card/custom_card.dart';
import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/common/components/text/text_icon.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/notification/model/notifications_model.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
  });
  final Notifications notification;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Mark as read
      },
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notification.fromFullName?.isNotEmpty ?? false)
              Text(
                notification.fromFullName ?? '',
                style: regularDefault,
              ),
            Text(
              notification.formattedDescription ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: lightDefault,
            ),
            const CustomDivider(space: Dimensions.space10),
            TextIcon(
                text: notification.date ?? '',
                icon: Icons.calendar_month_outlined),
          ],
        ),
      ),
    );
  }
}
