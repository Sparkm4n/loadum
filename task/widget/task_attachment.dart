import 'package:flutex_admin/common/components/no_data.dart';
import 'package:flutex_admin/core/helper/string_format_helper.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/task/model/task_details_model.dart';
import 'package:flutter/material.dart';

class TaskAttachments extends StatelessWidget {
  const TaskAttachments({
    super.key,
    required this.taskModel,
  });
  final TaskDetails taskModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.space15),
      child: taskModel.attachments!.isNotEmpty
          ? ListView.separated(
              itemBuilder: (context, index) {
                return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(Dimensions.cardRadius),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .shadowColor
                              .withValues(alpha: 0.05),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(Converter.fileType(
                          taskModel.attachments?[index].fileType ?? '')),
                      title: Text(
                        taskModel.attachments?[index].fileName ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      subtitle: Text(
                        taskModel.attachments?[index].fileType ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: lightSmall.copyWith(
                            color: ColorResources.blueGreyColor),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () {},
                      ),
                    ));
              },
              separatorBuilder: (context, index) =>
                  const SizedBox(height: Dimensions.space10),
              itemCount: taskModel.attachments!.length)
          : const NoDataWidget(),
    );
  }
}
