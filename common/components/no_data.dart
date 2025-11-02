import 'package:flutex_admin/core/utils/images.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:get/get.dart';

class NoDataWidget extends StatelessWidget {
  final double margin;
  final Color? color;
  final String text;
  const NoDataWidget({
    super.key,
    this.margin = 6,
    this.color,
    this.text = LocalStrings.noDataFound,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / margin),
      child: Column(
        children: [
          Image.asset(MyImages.noDataFound,
              width: MediaQuery.of(context).size.width / 2, color: color),
          const SizedBox(height: Dimensions.space20),
          Text(
            text.tr,
            textAlign: TextAlign.center,
            style: regularMediumLarge.copyWith(color: color),
          )
        ],
      ),
    );
  }
}
