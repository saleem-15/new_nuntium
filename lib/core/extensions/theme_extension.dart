import 'package:flutter/material.dart';

extension ThemeHelper on BuildContext {
  //  TextTheme الوصول السريع للـ
  TextTheme get textTheme => Theme.of(this).textTheme;

  TextStyle get headline1 => textTheme.headlineLarge!;
  TextStyle get body1 => textTheme.bodyMedium!;
  TextStyle get buttonText => textTheme.labelMedium!;

  Color get primaryColor => Theme.of(this).primaryColor;
}
