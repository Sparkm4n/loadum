import 'package:flutex_admin/common/components/circle_image_button.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/customer/model/contact_model.dart';

import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.index,
    required this.contactModel,
  });
  final int index;
  final ContactsModel contactModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.space5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.cardRadius),
          color: Theme.of(context).cardColor,
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
              imagePath: contactModel.data![index].profileImage ?? '',
              isAsset: false,
              isProfile: true,
              width: 60,
              height: 60,
            ),
          ),
          title: Text(
            '${contactModel.data![index].firstName} ${contactModel.data![index].lastName}',
            overflow: TextOverflow.ellipsis,
            style: regularDefault.copyWith(
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
          subtitle: Text(
            '${contactModel.data![index].email}',
            style: regularSmall.copyWith(color: ColorResources.blueColor),
          ),
          trailing: Switch(
            activeThumbColor: Colors.white,
            activeTrackColor: Theme.of(context).primaryColor,
            onChanged: (value) {},
            value: true,
          ),
        ),
      ),
    );
  }
}
