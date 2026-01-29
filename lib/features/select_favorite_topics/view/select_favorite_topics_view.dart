import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/core/theme/app_fonts.dart';
import 'package:new_nuntium/core/widgets/primary_button.dart';
import 'package:new_nuntium/features/select_favorite_topics/controller/select_favorite_topics_controller.dart';

class SelectFavoriteTopics
    extends GetView<SelectFavoriteTopicsController> {
  const SelectFavoriteTopics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 72.h),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppStrings.selectFavoriteTopicsTitle,
                style: context.headline1,
                textAlign: TextAlign.left,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              AppStrings.selectFavoriteTopicsSubTitle,
              style: context.body1,
            ),

            SizedBox(height: 32.h),

            GridView.builder(
              shrinkWrap: true,
              itemCount: controller.topics.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.w, // مسافة عمودية بين كل عنصر
                crossAxisSpacing: 16.w, // مسافة أفقية بين كل عنصر
                childAspectRatio:
                    2.5, // للتحكم في ارتفاع المربع بالنسبة لعرضه
              ),

              itemBuilder: (context, index) {
                final topic = controller.topics[index];

                return GestureDetector(
                  onTap: () => controller.toggleTopic(topic),
                  child: GetBuilder<SelectFavoriteTopicsController>(
                    assignId: true,
                    id: topic,
                    builder: (controller) {
                      final isSelected = controller.selectedTopics
                          .contains(topic);
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.purplePrimary
                              : AppColors.greyLighter,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          topic,
                          style: context.body1.copyWith(
                            color: isSelected
                                ? Colors.white
                                : AppColors.greyDarker,
                            fontWeight: AppFonts.semiBold,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            SizedBox(height: 16.h),

            PrimaryButton(
              text: AppStrings.next,
              onPressed: controller.onNextPressed,
            ),
          ],
        ),
      ),
    );
  }
}
