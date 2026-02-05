import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/core/theme/app_fonts.dart';
import 'package:new_nuntium/features/home/presentation/controller/home_controller.dart';

import '../../../../categories/domain/entities/category_entity.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return SizedBox(
      height: 34.h,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w),

        scrollDirection: Axis.horizontal,
        itemCount: controller.categories.length,
        itemBuilder: (_, index) {
          final category = controller.categories[index];
          final isLastItem = index == controller.categories.length - 1;
          return Padding(
            padding: EdgeInsetsDirectional.only(end: isLastItem ? 0 : 16.w),
            child: _CategoryItem(category: category),
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.category});
  final CategoryEntity category;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      final isSelected = controller.selectedCategory.value.id == category.id;
      return GestureDetector(
        onTap: () => controller.changeCategory(category),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.purplePrimary : AppColors.greyLighter,
            borderRadius: BorderRadius.circular(20.r),
          ),
          alignment: Alignment.center,
          child: Text(
            tr(category.name),
            style: TextStyle(
              fontSize: 12.sp,
              color: isSelected ? AppColors.white : AppColors.greyPrimary,
              fontWeight: AppFonts.semiBold,
            ),
          ),
        ),
      );
    });
  }
}
