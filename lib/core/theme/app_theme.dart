import 'package:flutter/material.dart';
import 'package:new_nuntium/core/theme/app_fonts.dart';
import 'package:new_nuntium/core/theme/app_text_styles.dart';
import 'app_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.purplePrimary,
    scaffoldBackgroundColor: AppColors.white,
    fontFamily: AppFonts.fontFamily,

    // هنا نقوم بتعريف ثيم النصوص الموحد للتطبيق
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.headLine1,
      bodyMedium: AppTextStyles.bodyText1,
      labelMedium: AppTextStyles.buttonText,
    ),
  );
}
