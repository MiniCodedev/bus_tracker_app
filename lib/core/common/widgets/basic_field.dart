import 'package:bus_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BasicField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final IconData icon;
  final bool isobscureText;
  final bool readOnly;
  final bool isNum;
  final Widget? suffixIcon;
  final void Function(String)? onChange;
  const BasicField({
    super.key,
    required this.controller,
    required this.icon,
    this.isobscureText = false,
    required this.hintText,
    this.readOnly = false,
    this.isNum = false,
    this.suffixIcon,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChange,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      inputFormatters: [
        if (isNum) FilteringTextInputFormatter.digitsOnly,
      ],
      readOnly: readOnly,
      controller: controller,
      obscureText: isobscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$hintText is missing!';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
