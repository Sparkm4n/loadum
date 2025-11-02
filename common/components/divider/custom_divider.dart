import 'package:flutter/material.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';

class CustomDivider extends StatelessWidget {
  final double space;
  final Color? color;
  final double? padding;

  const CustomDivider(
      {super.key, this.space = Dimensions.space20, this.padding, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding ?? 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: space),
          Divider(
              color: Theme.of(context).hintColor, height: 0.5, thickness: 0.5),
          SizedBox(height: space),
        ],
      ),
    );
  }
}
