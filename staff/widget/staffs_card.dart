import 'package:flutex_admin/common/components/circle_image_button.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/staff/model/staff_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffsCard extends StatelessWidget {
  const StaffsCard({super.key, required this.staffModel});
  final Staff staffModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteHelper.staffDetailsScreen, arguments: staffModel.id!);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.space5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.cardRadius),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Dimensions.space15,
              vertical: Dimensions.space10,
            ),
            leading: CircleAvatar(
              backgroundColor: ColorResources.blueGreyColor,
              radius: 32,
              child: CircleImageWidget(
                imagePath: staffModel.profileImage ?? '',
                isAsset: false,
                isProfile: true,
                width: 60,
                height: 60,
              ),
            ),
            title: Text(
              "${staffModel.firstName ?? ''} ${staffModel.lastName ?? ''}",
              overflow: TextOverflow.ellipsis,
              style: regularDefault.copyWith(
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
            subtitle: Text(
              staffModel.email ?? '',
              style: regularSmall.copyWith(color: ColorResources.blueColor),
            ),
            trailing: Text(
              staffModel.active == '1'
                  ? LocalStrings.active.tr
                  : LocalStrings.disabled.tr,
              style: regularSmall.copyWith(
                color: staffModel.active == '1'
                    ? ColorResources.greenColor
                    : ColorResources.blueGreyColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
