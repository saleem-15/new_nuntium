import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/widgets/app_back_button.dart';
import 'package:new_nuntium/features/language/presentation/controller/language_controller.dart';
import 'package:new_nuntium/features/language/presentation/view/language_list_tile.dart';

class LanguageView extends GetView<LanguageController> {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.language),
        leading: AppBackButton(),
      ),

      body: Padding(
        padding: EdgeInsets.only(right: 20.w, left: 20.w),
        child: Column(
          children: [
            // NuntiumAppBar(title: AppStrings.language),
            SizedBox(height: 32.h),

            GetBuilder<LanguageController>(
              builder: (controller) => ListView.builder(
                shrinkWrap: true,
                itemCount: controller.languages.length,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemBuilder: (context, index) {
                  final language =
                      controller.languages[index]; // تعريف المتغير لترتيب الكود
                  return LanguageListTile(
                    language: language,
                    isCurrentLocale: controller.isCurrentLocale(language),
                    onPressed: () =>
                        controller.onLanguageTilePressed(context, language),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
