import 'package:flutex_admin/common/components/text/label_text.dart';
import 'package:flutter/material.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class CustomMultiDropDownTextField extends StatefulWidget {
  final dynamic selectedValue;
  final String? labelText;
  final String? hintText;
  final MultiSelectController<Object>? controller;
  final List<DropdownItem<String>> items;
  final Function(dynamic)? onChanged;
  final Color? fillColor;
  final Color? iconColor;
  final double radius;
  final bool needLabel;

  const CustomMultiDropDownTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.selectedValue,
    required this.onChanged,
    required this.items,
    this.fillColor,
    this.iconColor,
    this.radius = Dimensions.defaultRadius,
    this.needLabel = false,
  });

  @override
  State<CustomMultiDropDownTextField> createState() =>
      _CustomMultiDropDownTextFieldState();
}

class _CustomMultiDropDownTextFieldState
    extends State<CustomMultiDropDownTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.needLabel
            ? LabelText(text: widget.labelText.toString())
            : const SizedBox(),
        widget.needLabel
            ? const SizedBox(height: Dimensions.textToTextSpace)
            : const SizedBox(),
        SizedBox(
          height: 50,
          child: MultiDropdown(
            controller: widget.controller,
            items: widget.items,
            onSelectionChange: widget.onChanged,
            fieldDecoration: FieldDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.radius),
                borderSide: BorderSide(
                  color: ColorResources.getUnselectedIconColor(),
                  width: 1,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.radius),
                borderSide: BorderSide(
                  color: ColorResources.getUnselectedIconColor(),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.radius),
                borderSide: BorderSide(
                  color: ColorResources.getUnselectedIconColor(),
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.radius),
                borderSide: const BorderSide(
                  color: ColorResources.colorRed,
                  width: 1,
                ),
              ),
              labelText: widget.labelText,
              labelStyle: regularDefault,
              hintText: widget.hintText,
              hintStyle: regularDefault.copyWith(
                color: Theme.of(context).hintColor,
              ),
              backgroundColor: Theme.of(context).cardColor,
            ),
            chipDecoration: ChipDecoration(
              wrap: true,
              labelStyle: regularDefault.copyWith(
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
            dropdownDecoration: DropdownDecoration(
              backgroundColor: Theme.of(context).cardColor,
            ),
          ),
        ),
      ],
    );
  }
}
