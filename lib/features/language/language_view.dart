import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/features/language/language_controller.dart';
import 'package:new_nuntium/features/language/language_list_tile.dart';

class LanguageView extends GetView<LanguageController> {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(right: 20.w, left: 20.w, top: 72.h),
        child: Column(
          children: [
            _languageAppBar(context),

            SizedBox(height: 32.h),

            ListView.builder(
              itemCount: controller.languages.length,
              shrinkWrap: true,
              itemBuilder: (_, index) {
                final language = controller.languages[index];
                return LanguageListTile(languageName: language);
              },
            ),
          ],
        ),
      ),
    );
  }

  Stack _languageAppBar(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: -5.h,
          child: IconButton(
            onPressed: controller.onBackButtonPressed,
            icon: Icon(Icons.arrow_back_rounded),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(AppStrings.language, style: context.headline1),
        ),
      ],
    );
  }
}
