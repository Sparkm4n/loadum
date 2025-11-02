import 'package:flutex_admin/core/helper/string_format_helper.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/lead/controller/lead_details_controller.dart';
import 'package:flutex_admin/features/lead/model/lead_details_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttachmentCard extends StatelessWidget {
  const AttachmentCard({
    super.key,
    required this.index,
    required this.attachment,
  });
  final int index;
  final List<Attachments> attachment;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: ListTile(
          leading: Icon(Converter.fileType(attachment[index].fileType ?? '')),
          title: Text(
            '${attachment[index].fileName}',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          subtitle: Text(
            '${attachment[index].fileType}',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: lightSmall.copyWith(color: ColorResources.blueGreyColor),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => Get.find<LeadDetailsController>()
                .downloadAttachment(attachment[index].fileType ?? '',
                    attachment[index].attachmentKey ?? ''),
          ),
        ));
  }
}
