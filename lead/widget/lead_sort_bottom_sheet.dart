import 'package:flutex_admin/common/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:flutex_admin/common/components/card/custom_card.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/lead/controller/lead_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeadSortBottomSheet extends StatefulWidget {
  const LeadSortBottomSheet({super.key});

  @override
  State<LeadSortBottomSheet> createState() => _LeadSortBottomSheetState();
}

class _LeadSortBottomSheetState extends State<LeadSortBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Dimensions.space10,
      children: [
        BottomSheetHeaderRow(header: LocalStrings.sortBy.tr, bottomSpace: 0),
        buildListTile(
          leadingIcon: Icons.sort,
          title: '${LocalStrings.lead.tr} ${LocalStrings.id.tr}',
          onTap: () {
            Get.back();
            final controller = Get.put(LeadController(leadRepo: Get.find()));
            controller.sortBy = 'id';
            controller.initialData();
          },
        ),
        buildListTile(
          leadingIcon: Icons.date_range_outlined,
          title: LocalStrings.newestFirst.tr,
          onTap: () {
            Get.back();
            final controller = Get.put(LeadController(leadRepo: Get.find()));
            controller.sortBy = 'date_desc';
            controller.initialData();
          },
        ),
        buildListTile(
          leadingIcon: Icons.date_range_outlined,
          title: LocalStrings.oldestFirst.tr,
          onTap: () {
            Get.back();
            final controller = Get.put(LeadController(leadRepo: Get.find()));
            controller.sortBy = 'date_asc';
            controller.initialData();
          },
        ),
        buildListTile(
          leadingIcon: Icons.sort_by_alpha,
          title: LocalStrings.nameAZ.tr,
          onTap: () {
            Get.back();
            final controller = Get.put(LeadController(leadRepo: Get.find()));
            controller.sortBy = 'name_asc';
            controller.initialData();
          },
        ),
        buildListTile(
          leadingIcon: Icons.sort_by_alpha,
          title: LocalStrings.nameZA.tr,
          onTap: () {
            Get.back();
            final controller = Get.put(LeadController(leadRepo: Get.find()));
            controller.sortBy = 'name_desc';
            controller.initialData();
          },
        ),
        const SizedBox(height: Dimensions.space10),
      ],
    );
  }

  Widget buildListTile({
    required IconData leadingIcon,
    required String title,
    required VoidCallback onTap,
  }) {
    return CustomCard(
      padding: Dimensions.space5,
      child: ListTile(
        leading: Icon(
          leadingIcon,
          color: Theme.of(Get.context!).textTheme.bodyLarge!.color,
        ),
        title: Text(
          title,
          style: regularDefault.copyWith(
            color: Theme.of(Get.context!).textTheme.bodyLarge!.color,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: Dimensions.space12,
          color: ColorResources.contentTextColor,
        ),
        onTap: onTap,
      ),
    );
  }
}
