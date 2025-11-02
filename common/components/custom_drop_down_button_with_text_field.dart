import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:get/get.dart';

class CustomDropDownWithTextField extends StatefulWidget {
  final String? title, selectedValue;
  final List<String>? list;
  final ValueChanged? onChanged;

  const CustomDropDownWithTextField({
    super.key,
    this.title,
    this.selectedValue,
    this.list,
    this.onChanged,
  });

  @override
  State<CustomDropDownWithTextField> createState() =>
      _CustomDropDownWithTextFieldState();
}

class _CustomDropDownWithTextFieldState
    extends State<CustomDropDownWithTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.list?.removeWhere((element) => element.isEmpty);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(Dimensions.defaultRadius),
            ),
            border: Border.all(color: ColorResources.getUnselectedIconColor()),
          ),
          child: DropdownButton(
            isExpanded: true,
            underline: Container(),
            hint: Text(
              widget.selectedValue?.tr ?? '',
              style: regularDefault.copyWith(
                color: ColorResources.contentTextColor,
              ),
            ),
            value: widget.selectedValue,
            onChanged: widget.onChanged,
            items: widget.list!.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(
                  value.tr,
                  style: regularDefault.copyWith(
                    color: ColorResources.contentTextColor,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
