import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/common/models/items_model.dart';
import 'package:flutter/material.dart';

class TableItem extends StatelessWidget {
  const TableItem({super.key, required this.item, this.currency});
  final Item item;
  final String? currency;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width / 1.5,
              child: Text(
                item.description ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: regularDefault,
              ),
            ),
            Text(
              '${currency ?? ''}${item.rate} x ${item.qty?.replaceAll('.00', '')} ${item.unit}',
              style: regularDefault.copyWith(
                color: ColorResources.blueGreyColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: Dimensions.space5),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${currency ?? ''}${double.parse(item.rate ?? '0') * double.parse(item.qty ?? '0')}',
              style: regularLarge,
            ),
          ],
        ),
      ],
    );
  }
}
