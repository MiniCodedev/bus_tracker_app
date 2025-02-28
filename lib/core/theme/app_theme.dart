import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
    ),
    colorSchemeSeed: AppColors.primaryColor,
    fontFamily: "Poppins",
    useMaterial3: true,
  );
}
