import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: ManagerColors.purplePrimary,
    scaffoldBackgroundColor: ManagerColors.white,
    fontFamily: 'SF_Pro',

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: ManagerColors.blackPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: ManagerColors.greyPrimary,
        fontSize: 16,
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: ManagerColors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: ManagerColors.blackPrimary),
    ),
  );
}
