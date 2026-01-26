import 'package:get/get.dart';

import '../resources/app_strings.dart'; // لاستخدام النصوص المترجمة

class AppValidator {
  AppValidator._();

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    if (!GetUtils.isEmail(value)) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    if (value.length < 6) {
      return AppStrings.tooShort;
    }
    return null;
  }

  static String? validateMatchPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    if (value != password) {
      return AppStrings.passwordsDontMatch;
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }

    //Allows characters from all languages & spaces
    final nameRegExp = RegExp(r'^[\p{L}\s]+$', unicode: true);

    if (value.length < 3) {
      return AppStrings.tooShort;
    } else if (value.length > 15) {
      return AppStrings.usernameLengthError;
    } else if (!nameRegExp.hasMatch(value)) {
      return AppStrings.usernameLettersError;
    }

    return null;
  }
}
