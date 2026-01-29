import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/core/services/language_service.dart';
import 'package:new_nuntium/features/language/model/language.dart';

class LanguageController extends GetxController {
  LanguageService localeSettings = Get.find<LanguageService>();
  // يُفضل تعيين النوع بوضوح
  Locale get currentLocale => localeSettings.currentLocale;

  List<Language> languages = [];

  @override
  void onInit() {
    initLanguageList();
    super.onInit();
  }

  void initLanguageList() {
    languages = LanguageService.supportedLanguages.entries
        .map((e) => Language(langCode: e.key, name: e.value))
        .toList();
  }

  Future<void> onLanguageTilePressed(
    BuildContext context,
    Language language,
  ) async {
    await localeSettings.changeLanguage(context, language.langCode);
    log(language.name);

    update();
  }

  bool isCurrentLocale(Language language) {
    return currentLocale.languageCode == language.langCode;
  }

  void onBackButtonPressed() {
    Get.back();
  }
}
