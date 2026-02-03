import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_nuntium/core/theme/app_fonts.dart';
import 'package:new_nuntium/core/theme/app_text_styles.dart';

import 'app_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.purplePrimary,
    scaffoldBackgroundColor: AppColors.white,
    fontFamily: AppFonts.fontFamily,

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      titleTextStyle: AppTextStyles.headLine1,
    ),

    // هنا نقوم بتعريف ثيم النصوص الموحد للتطبيق
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.headLine1,
      bodyMedium: AppTextStyles.bodyText1,
      bodyLarge: AppTextStyles.bodyText1,
      labelMedium: AppTextStyles.buttonText,
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.purplePrimary,
      selectionHandleColor: AppColors.purplePrimary,
      selectionColor: AppColors.purpleLight.withValues(alpha: .5),
    ),
  );
}
