import 'package:date_field/date_field.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:get/get.dart';

class CustomDateFormField extends StatelessWidget {
  final String labelText;
  final Function(DateTime? value) onChanged;
  final DateTime? initialValue;
  final DateTimeFieldPickerMode? mode;
  final FormFieldValidator? validator;
  final AutovalidateMode autovalidateMode;

  const CustomDateFormField({
    super.key,
    required this.labelText,
    required this.onChanged,
    this.initialValue,
    this.mode,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  @override
  Widget build(BuildContext context) {
    return DateTimeFormField(
      decoration: InputDecoration(
        focusColor: Colors.red,
        contentPadding: const EdgeInsets.only(
          top: 5,
          left: 15,
          right: 15,
          bottom: 5,
        ),
        labelText: labelText,
        labelStyle: regularDefault.copyWith(color: Theme.of(context).hintColor),
        fillColor: Theme.of(context).cardColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: ColorResources.getUnselectedIconColor(),
          ),
          borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: ColorResources.getUnselectedIconColor(),
          ),
          borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: ColorResources.getUnselectedIconColor(),
          ),
          borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
        ),
        suffixIcon: Icon(
          Icons.calendar_month,
          size: 25,
          color: Theme.of(context).hintColor,
        ),
      ),
      materialDatePickerOptions: MaterialDatePickerOptions(
        confirmText: LocalStrings.confirm.tr,
        cancelText: LocalStrings.cancel.tr,
      ),
      style: regularDefault.copyWith(
        color: Theme.of(context).textTheme.bodyMedium!.color,
      ),
      mode: mode ?? DateTimeFieldPickerMode.date,
      autovalidateMode: autovalidateMode,
      validator: validator,
      initialValue: initialValue,
      onChanged: onChanged,
    );
  }
}
