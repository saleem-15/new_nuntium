import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.purplePrimary,
    scaffoldBackgroundColor: AppColors.white,
    fontFamily: 'SF_Pro',

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: AppColors.blackPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: AppColors.greyPrimary,
        fontSize: 16,
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.blackPrimary),
    ),
  );
}
