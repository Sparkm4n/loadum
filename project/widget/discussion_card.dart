import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/common/components/text/text_icon.dart';
import 'package:flutex_admin/core/helper/date_converter.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/project/model/project_discussions_model.dart';
import 'package:flutter/material.dart';

class DiscussionCard extends StatelessWidget {
  const DiscussionCard({super.key, required this.discussion});
  final Discussion discussion;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.space15),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 2,
                    child: Text(
                      discussion.subject ?? '',
                      style: regularDefault,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  TextIcon(
                    text: discussion.showToCustomer == '1'
                        ? LocalStrings.visible
                        : LocalStrings.notVisible,
                    textStyle: lightSmall.copyWith(
                      color: discussion.showToCustomer == '1'
                          ? Colors.green
                          : Colors.red,
                    ),
                    icon: discussion.showToCustomer == '1'
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ],
              ),
              const CustomDivider(space: Dimensions.space8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextIcon(
                    text:
                        '${LocalStrings.totalComments}: ${discussion.totalComments}',
                    icon: Icons.account_box_rounded,
                  ),
                  TextIcon(
                    text: DateConverter.formatValidityDate(
                      discussion.lastActivity ?? '',
                    ),
                    icon: Icons.calendar_month,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
