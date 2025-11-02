import 'package:flutex_admin/core/helper/string_format_helper.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/staff/model/staff_details_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffPermission extends StatelessWidget {
  const StaffPermission({super.key, required this.staffModel});
  final StaffDetails staffModel;

  @override
  Widget build(BuildContext context) {
    return staffModel.permissions?.isNotEmpty ?? false
        ? ListView.separated(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return CheckboxListTile(
                title: Text(
                  staffModel.permissions?[index].feature?.toCapitalized() ?? '',
                  style: regularDefault.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
                subtitle: Text(
                  staffModel.permissions?[index].capability?.toCapitalized() ??
                      '',
                  style: lightSmall.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
                value: true,
                checkColor: ColorResources.colorWhite,
                activeColor: ColorResources.secondaryColor,
                onChanged: (value) {},
              );
            },
            separatorBuilder: (context, index) => Divider(height: 0),
            itemCount: staffModel.permissions!.length,
          )
        : Center(child: Text(LocalStrings.noPermissionAssigned.tr));
  }
}
