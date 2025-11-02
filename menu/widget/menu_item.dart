import 'package:flutex_admin/common/components/image/custom_svg_picture.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/style.dart';

class MenuItems extends StatelessWidget {
  final String? imageSrc;        // optional: PNG/SVG
  final IconData? leadingIcon;   // optional: Material-Icon
  final String label;
  final VoidCallback onPressed;
  final bool isSvgImage;
  final bool selected;
  final bool showChevron;

  const MenuItems({
    super.key,
    this.imageSrc,
    this.leadingIcon,
    required this.label,
    required this.onPressed,
    this.isSvgImage = true,
    this.selected = false,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color baseText = theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurface;
    final Color textColor = selected ? theme.colorScheme.primary : baseText;

    Widget leading() {
      if (leadingIcon != null) return Icon(leadingIcon, size: 18, color: textColor);
      if (imageSrc != null && imageSrc!.isNotEmpty) {
        return isSvgImage
            ? CustomSvgPicture(image: imageSrc!, color: textColor, height: 18, width: 18)
            : Image.asset(imageSrc!, height: 18, width: 18, color: textColor);
      }
      return Icon(Icons.circle, size: 6, color: textColor.withOpacity(.6));
    }

    return Material(
      color: selected ? theme.colorScheme.primary.withOpacity(0.08) : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.space5,
            horizontal: Dimensions.space10,
          ),
          decoration: BoxDecoration(
            color: ColorResources.transparentColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                SizedBox(height: 36, width: 36, child: Center(child: leading())),
                const SizedBox(width: Dimensions.space15),
                Text(
                  label.tr,
                  style: regularDefault.copyWith(
                    color: textColor,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ]),
              if (showChevron) Icon(Icons.arrow_forward_ios_rounded, size: 15, color: textColor),
            ],
          ),
        ),
      ),
    );
  }
}
