import 'package:flutex_admin/common/components/text/label_text.dart';
import 'package:flutter/material.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/style.dart';

class CustomDropDownTextField extends StatefulWidget {
  final dynamic selectedValue;
  final String? labelText;
  final String? hintText;
  final Function(dynamic)? onChanged;
  final List<DropdownMenuItem<dynamic>>? items;
  final Color? fillColor;
  final Color? focusColor;
  final Color? dropDownColor;
  final Color? iconColor;
  final double radius;
  final bool needLabel;
  final FormFieldValidator? validator;

  const CustomDropDownTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.selectedValue,
    required this.onChanged,
    required this.items,
    this.fillColor,
    this.focusColor,
    this.dropDownColor,
    this.iconColor,
    this.radius = Dimensions.defaultRadius,
    this.needLabel = false,
    this.validator,
  });

  @override
  State<CustomDropDownTextField> createState() =>
      _CustomDropDownTextFieldState();
}

class _CustomDropDownTextFieldState extends State<CustomDropDownTextField> {
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
        DropdownButtonFormField(
          initialValue:
              (widget.selectedValue != '' &&
                  widget.selectedValue != null &&
                  widget.selectedValue != '0')
              ? widget.selectedValue
              : null,
          dropdownColor: widget.dropDownColor ?? Theme.of(context).cardColor,
          focusColor: widget.focusColor ?? Theme.of(context).cardColor,
          hint: Text(widget.hintText.toString()),
          style: regularDefault,
          //alignment: Alignment.centerLeft,
          decoration: InputDecoration(
            hintText: widget.hintText.toString(),
            filled: true,
            fillColor: widget.fillColor ?? Theme.of(context).cardColor,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: const BorderSide(
                color: ColorResources.textFieldDisableBorderColor,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: BorderSide(
                color: ColorResources.getUnselectedIconColor(),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: const BorderSide(
                color: ColorResources.primaryColor,
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
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: const BorderSide(
                color: ColorResources.textFieldDisableBorderColor,
                width: 1,
              ),
            ),
          ),
          isExpanded: true,
          validator: widget.validator,
          onChanged: widget.onChanged,
          items: widget.items,
          icon: Icon(
            Icons.arrow_drop_down,
            color:
                widget.iconColor ??
                Theme.of(context).textTheme.bodyMedium!.color,
          ),
        ),
      ],
    );
  }
}
