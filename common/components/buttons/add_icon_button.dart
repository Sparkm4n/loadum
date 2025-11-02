import 'package:flutex_admin/common/components/text/text_icon.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';

class AddIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color, iconColor;
  final double iconSize;
  final String? text;
  final TextStyle? textStyle;

  const AddIconButton({
    super.key,
    this.icon = Icons.add,
    required this.onTap,
    this.color = ColorResources.secondaryColor,
    this.iconColor = Colors.white,
    this.iconSize = 30.00,
    this.text,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: Dimensions.space5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
        ),
        child: text != null
            ? TextIcon(
                text: text ?? '',
                icon: icon,
                iconColor: iconColor,
                iconSize: iconSize,
                textStyle:
                    textStyle ?? regularDefault.copyWith(color: iconColor),
                alignment: MainAxisAlignment.center,
              )
            : Icon(icon, color: iconColor, size: iconSize),
      ),
    );
  }
}
