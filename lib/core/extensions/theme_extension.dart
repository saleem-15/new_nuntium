import 'package:flutter/material.dart';

extension ThemeHelper on BuildContext {
  //  TextTheme الوصول السريع للـ
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// * **Size:** `24.sp`
  /// * **Weight:** `SemiBold`
  /// * **Color:** `blackPrimary`
  TextStyle get headline1 => textTheme.headlineLarge!;

  /// * **Size:** `16.sp`
  /// * **Weight:** `regular`
  /// * **Color:** `greyPrimary`
  TextStyle get body1 => textTheme.bodyMedium!;

  /// * **Size:** `16.sp`
  /// * **Weight:** `regular`
  /// * **Color:** `blackPrimary`
  TextStyle get body2 => textTheme.bodyLarge!;

  /// * **Size:** `16.sp`
  /// * **Weight:** `semiBold`
  /// * **Color:** `white`
  TextStyle get buttonText => textTheme.labelMedium!;

  Color get primaryColor => Theme.of(this).primaryColor;
}
