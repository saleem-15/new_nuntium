import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/core/constants/app_assets.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/features/main/controller/main_controller.dart';

class MainBottomNavBar extends GetView<MainController> {
  const MainBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,

            currentIndex: controller.currentPageIndex.value,
            onTap: controller.changePage,
            // لضمان ظهور 4 أيقونات بشكل متساوي
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              _buildNavItem(AppIcons.home, 0),
              _buildNavItem(AppIcons.category, 1),
              // _buildNavItem(AppIcons.bookmark, 2),
              // _buildNavItem(AppIcons.profile, 3),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(String iconPath, int index) {
    bool isSelected = controller.currentPageIndex.value == index;
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        colorFilter: ColorFilter.mode(
          isSelected
              ? AppColors.purplePrimary
              : AppColors.greyPrimary,
          BlendMode.srcIn,
        ),
      ),
      label: '',
    );
  }
}
