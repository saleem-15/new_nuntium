import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:get/get.dart';
import 'package:new_nuntium/config/dependency_injection.dart';
import 'package:new_nuntium/core/constants/constanst.dart';
import 'package:new_nuntium/core/services/shared_prefrences.dart';

class LanguageService {
  LanguageService() {
    _preferences = getIt<AppSharedPrefs>();
    currentLocale = Locale(_preferences.locale ?? Constants.englishKey);
  }
  late final AppSharedPrefs _preferences;
  late Locale currentLocale;

  static const Map<String, String> supportedLanguages = {
    Constants.arabicKey: Constants.arabic,
    Constants.englishKey: Constants.english,
  };

  List<Locale> get supportedLocales =>
      supportedLanguages.keys.map((e) => Locale(e)).toList();

  Locale get fallBackLocale => Locale(Constants.arabicKey);
  // Text direction based on the current language
  static TextDirection getTextDirection(BuildContext context) {
    return context.locale.languageCode == Constants.arabicKey
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  Future<void> changeLanguage(BuildContext context, String langCode) async {
    Locale newLocale = Locale(langCode);
    currentLocale = newLocale;

    // 1. Easy Localization updates text
    await context.setLocale(newLocale);

    // 2.  GetX updates the app
    Get.updateLocale(newLocale);

    //3. Save the language (When the app starts again it will open with this language)
    _preferences.setLocale(langCode);
  }
}
