import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/theme/app_fonts.dart';
import 'package:new_nuntium/core/widgets/nuntium_app_bar.dart';
import 'package:new_nuntium/features/terms_and_conditions/presentation/controller/terms_and_conditions_controller.dart';

class TermsAndConditionsView extends GetView<TermsAndConditionsController> {
  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NuntiumAppBar(title: AppStrings.termsAndConditions),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(right: 20.w, left: 20.w, bottom: 30.h),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Text(
                AppStrings.termsAndConditionsBody,
                style: context.body1.copyWith(fontWeight: AppFonts.semiBold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
