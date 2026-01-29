import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/core/constants/app_assets.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/features/bookmarks/presentation/view/bookmarks_view.dart';
import 'package:new_nuntium/features/categories/views/categories_view.dart';
import 'package:new_nuntium/features/home/presentation/view/home_page.dart';
import 'package:new_nuntium/features/main/controller/main_controller.dart';
import 'package:new_nuntium/features/profile/view/profile_view.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      // The list of tabs and their configurations
      tabs: _tabs(),

      // Using navBarBuilder to customize the decoration of Style 12
      navBarBuilder: (navBarConfig) => Style10BottomNavBar(
        navBarConfig: navBarConfig,
        height: 60.h,
        itemAnimationProperties: ItemAnimation(
          duration: Duration(milliseconds: 400),
        ),
        navBarDecoration: NavBarDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            topRight: Radius.circular(12.r),
          ),

          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -1),
              color: AppColors.greyLight.withValues(alpha: 0.32),
              blurRadius: 0,
              spreadRadius: 0,
            ),
          ],
        ),
      ),

      onTabChanged: controller.onNavigationBarItemTapped,
    );
  }

  List<PersistentTabConfig> _tabs() {
    return [
      /// Home Tab Configuration
      PersistentTabConfig(
        screen: const HomeView(),
        item: ItemConfig(
          icon: SvgPicture.asset(
            AppIcons.home,
            colorFilter: const ColorFilter.mode(
              AppColors.purplePrimary,
              BlendMode.srcIn,
            ),
          ),
          inactiveIcon: SvgPicture.asset(
            AppIcons.home,
            colorFilter: const ColorFilter.mode(
              AppColors.greyPrimary,
              BlendMode.srcIn,
            ),
          ),
          activeForegroundColor: AppColors.purplePrimary,
          inactiveForegroundColor: AppColors.greyPrimary,
        ),
      ),

      /// Categories Tab Configuration
      PersistentTabConfig(
        screen: const CategoriesView(),
        item: ItemConfig(
          icon: SvgPicture.asset(
            AppIcons.category,
            colorFilter: const ColorFilter.mode(
              AppColors.purplePrimary,
              BlendMode.srcIn,
            ),
          ),

          inactiveIcon: SvgPicture.asset(
            AppIcons.category,
            colorFilter: const ColorFilter.mode(
              AppColors.greyPrimary,
              BlendMode.srcIn,
            ),
          ),
          activeForegroundColor: AppColors.purplePrimary,
          inactiveForegroundColor: AppColors.greyPrimary,
        ),
      ),

      // Bookmarks Tab Configuration
      PersistentTabConfig(
        screen: const BookmarksView(),
        item: ItemConfig(
          icon: SvgPicture.asset(
            AppIcons.bookmark,
            colorFilter: const ColorFilter.mode(
              AppColors.purplePrimary,
              BlendMode.srcIn,
            ),
          ),
          inactiveIcon: SvgPicture.asset(
            AppIcons.bookmark,
            colorFilter: const ColorFilter.mode(
              AppColors.greyPrimary,
              BlendMode.srcIn,
            ),
          ),
          activeForegroundColor: AppColors.purplePrimary,
          inactiveForegroundColor: AppColors.greyPrimary,
        ),
      ),

      /// Profile Tab Configuration
      PersistentTabConfig(
        screen: const ProfileView(),
        item: ItemConfig(
          icon: SvgPicture.asset(
            AppIcons.user,
            colorFilter: const ColorFilter.mode(
              AppColors.purplePrimary,
              BlendMode.srcIn,
            ),
          ),
          inactiveIcon: SvgPicture.asset(
            AppIcons.user,
            colorFilter: const ColorFilter.mode(
              AppColors.greyPrimary,
              BlendMode.srcIn,
            ),
          ),
          activeForegroundColor: AppColors.purplePrimary,
          inactiveForegroundColor: AppColors.greyPrimary,
        ),
      ),
    ];
  }
}
