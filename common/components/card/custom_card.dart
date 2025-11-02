import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/util.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final double padding;
  final EdgeInsets? margin;
  final double? width;
  final double radius;
  final VoidCallback? onPressed;
  final Widget child;
  final bool isPress;

  const CustomCard({
    super.key,
    this.width,
    this.margin,
    this.padding = Dimensions.space15,
    this.radius = Dimensions.cardRadius,
    this.onPressed,
    this.isPress = false,
    required this.child,
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return widget.isPress
        ? GestureDetector(
            onTap: widget.onPressed,
            child: Container(
              width: widget.width,
              margin: widget.margin,
              padding: EdgeInsets.all(widget.padding),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(widget.radius),
                boxShadow: MyUtils.getCardShadow(context),
              ),
              child: widget.child,
            ),
          )
        : Container(
            width: widget.width,
            margin: widget.margin,
            padding: EdgeInsets.all(widget.padding),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(
                color: ColorResources.getUnselectedIconColor(),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(widget.radius),
              boxShadow: MyUtils.getCardShadow(context),
            ),
            child: widget.child,
          );
  }
}
