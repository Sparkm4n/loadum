import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/common/components/text/text_icon.dart';
import 'package:flutex_admin/core/helper/date_converter.dart';
import 'package:flutex_admin/core/route/route.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/features/contract/model/contract_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContractCard extends StatelessWidget {
  const ContractCard({
    super.key,
    required this.index,
    required this.contractModel,
  });

  final int index;
  final ContractsModel contractModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = contractModel.data![index];

    final bool isSigned = (data.signed ?? '0') != '0';
    final Color statusColor =
    ColorResources.contractStatusColor(data.signed ?? '0');
    final String statusText =
    isSigned ? LocalStrings.signed.tr : LocalStrings.notSigned.tr;

    // Safe strings
    final String subject = (data.subject ?? '').trim().isEmpty
        ? 'Untitled'
        : (data.subject ?? '').trim();
    final String value = (data.contractValue ?? '').trim().isEmpty
        ? '-'
        : (data.contractValue ?? '').trim();
    final String company = (data.company ?? '').trim().isEmpty
        ? '-'
        : (data.company ?? '').trim();
    final String created =
    DateConverter.formatValidityDate(data.dateAdded ?? '');

    return Semantics(
      label: 'Contract: $subject, ${isSigned ? "signed" : "not signed"}',
      button: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.space5,
          vertical: Dimensions.space5,
        ),
        child: Material(
          color: theme.cardColor,
          elevation: 0,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Get.toNamed(
              RouteHelper.contractDetailsScreen,
              arguments: data.id,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withValues(alpha: 0.05),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border(
                  left: BorderSide(
                    width: 4,
                    color: isSigned
                        ? Colors.lightBlue.shade600
                        : Colors.orange.shade400,
                  ),
                ),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Subject + Status chip
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          subject,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: regularDefault.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusChip(text: statusText, color: statusColor),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Beschreibung (optional)
                  if ((data.description ?? '').trim().isNotEmpty) ...[
                    Text(
                      data.description!.trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: lightSmall.copyWith(
                        color: ColorResources.blueGreyColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],

                  const CustomDivider(space: Dimensions.space5),

                  // Company & Date
                  Row(
                    children: [
                      Expanded(
                        child: TextIcon(
                          text: company,
                          icon: Icons.storefront_outlined,
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextIcon(
                        text: created,
                        icon: Icons.calendar_month,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Value + chevron
                  Row(
                    children: [
                      Icon(Icons.receipt_long_rounded,
                          size: 18, color: theme.colorScheme.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: regularDefault.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded,
                          color: Colors.grey, size: 22),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(.35)),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          letterSpacing: .2,
        ),
      ),
    );
  }
}
