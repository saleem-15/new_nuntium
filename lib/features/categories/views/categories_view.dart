import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/core/theme/app_fonts.dart';
import 'package:new_nuntium/core/widgets/header.dart';
import 'package:new_nuntium/features/categories/controller/categories_controller.dart';
import 'package:new_nuntium/features/select_favorite_topics/controller/select_favorite_topics_controller.dart';

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Header(
              title: AppStrings.categoriesPageTitle,
              subTtitle: AppStrings.categoriesPageSubTitle,
            ),

            GridView.builder(
              shrinkWrap: true,
              itemCount: controller.categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.w, // مسافة عمودية بين كل عنصر
                crossAxisSpacing: 16.w, // مسافة أفقية بين كل عنصر
                childAspectRatio:
                    2.5, // للتحكم في ارتفاع المربع بالنسبة لعرضه
              ),

              itemBuilder: (context, index) {
                final topic = controller.categories[index];

                return GestureDetector(
                  onTap: controller.onCategoryPressed,
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
          ],
        ),
      ),
    );
  }
}
