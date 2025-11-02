import 'package:flutex_admin/common/components/card/custom_card.dart';
import 'package:flutex_admin/common/components/circle_image_button.dart';
import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/staff/model/staff_details_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffProfile extends StatelessWidget {
  const StaffProfile({super.key, required this.staffModel});
  final StaffDetails staffModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.space10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(Dimensions.space10),
            child: CircleImageWidget(
              isAsset: false,
              imagePath: staffModel.profileImage ?? '',
              isProfile: true,
              height: 100,
              width: 100,
            ),
          ),
          CustomCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(LocalStrings.firstName.tr, style: lightSmall),
                    Text(LocalStrings.lastName.tr, style: lightSmall),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(staffModel.firstName ?? ''),
                    Text(staffModel.lastName ?? ''),
                  ],
                ),
                const CustomDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(LocalStrings.email.tr, style: lightSmall),
                    Text(LocalStrings.phone.tr, style: lightSmall),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(staffModel.email ?? ''),
                    Text(staffModel.phoneNumber ?? ''),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.space20),
          CustomCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(LocalStrings.hourlyRate.tr, style: lightSmall),
                    Text(LocalStrings.facebook.tr, style: lightSmall),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(staffModel.hourlyRate ?? '-'),
                    Text(staffModel.facebook ?? '-'),
                  ],
                ),
                const CustomDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(LocalStrings.linkedIn.tr, style: lightSmall),
                    Text(LocalStrings.skype.tr, style: lightSmall),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(staffModel.linkedin ?? '-'),
                    Text(staffModel.skype ?? '-'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
