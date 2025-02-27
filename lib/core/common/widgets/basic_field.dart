import 'package:bus_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BasicField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final IconData icon;
  final bool isobscureText;
  const BasicField(
      {super.key,
      required this.controller,
      required this.icon,
      this.isobscureText = false,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
