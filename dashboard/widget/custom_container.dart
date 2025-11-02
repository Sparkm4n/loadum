import 'package:flutter/material.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/style.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.name,
    required this.number,
    required this.color,
    this.icon,
    this.iconSize,
    this.onTap,
    this.backgroundColor,
  });

  final String name;
  final String number;
  final Color color;

  /// Optional leading icon
  final IconData? icon;

  /// Size for the optional icon (defaults to 20)
  final double? iconSize;

  /// Optional tap handler (keeps the same layout; ripple added when provided)
  final VoidCallback? onTap;

  /// Optional custom background (defaults to theme.cardColor)
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color;

    final content = Container(
      height: Dimensions.space80,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardColor,
        borderRadius: BorderRadius.circular(Dimensions.cardRadius),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05), // web-safe
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: Dimensions.space5),
            child: Row(
              mainAxisAlignment: icon != null
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                if (icon != null)
                  Icon(icon, size: iconSize ?? 20, color: color),
                // Flexible avoids overflow when numbers are long
                Flexible(
                  child: Text(
                    number,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: icon != null ? TextAlign.right : TextAlign.center,
                    style: mediumExtraLarge.copyWith(color: color),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.space5),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: regularSmall.copyWith(color: textColor),
          ),
        ],
      ),
    );

    // Keep Expanded like your original so it drops into a Row of 2–3 items.
    // If you ever need it outside a Row/Flex, wrap this widget with SizedBox/Expanded at the callsite.
    return Expanded(
      child: onTap == null
          ? content
          : Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Dimensions.cardRadius),
          child: content,
        ),
      ),
    );
  }
}
