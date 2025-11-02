import 'package:flutex_admin/common/components/card/custom_card.dart';
import 'package:flutex_admin/common/components/circle_image_button.dart';
import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/lead/model/notes_model.dart';
import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.index,
    required this.note,
  });
  final int index;
  final List<Note> note;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: Dimensions.space10,
            children: [
              Container(
                height: 40,
                width: 40,
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                        width: .3, color: Theme.of(context).primaryColor)),
                child: CircleImageWidget(
                  isProfile: true,
                  imagePath: note[index].profileImage ?? '',
                  height: 35,
                  width: 35,
                  isAsset: false,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${note[index].firstName} ${note[index].lastName}',
                    style: regularDefault.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium!.color),
                  ),
                  Text(
                    '${LocalStrings.date}: ${note[index].dateAdded}',
                    style: lightSmall.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium!.color),
                  ),
                ],
              ),
              const Spacer(),
              if (note[index].dateContacted != null)
                Tooltip(
                  message: note[index].dateContacted,
                  child: const Icon(
                    Icons.call,
                    color: ColorResources.colorGreen,
                  ),
                ),
            ],
          ),
          const CustomDivider(space: Dimensions.space10),
          Text(
            '${note[index].description}',
            style: lightSmall.copyWith(
                color: Theme.of(context).textTheme.bodyMedium!.color),
          ),
        ],
      ),
    );
  }
}
