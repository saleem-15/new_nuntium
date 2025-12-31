import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/core/theme/app_fonts.dart';
import 'package:new_nuntium/core/widgets/header.dart';
import 'package:new_nuntium/features/home/controller/home_page._controller.dart';
import 'package:new_nuntium/features/home/view/widgets/category_selector.dart';
import 'package:new_nuntium/features/home/view/widgets/home_search_bar.dart';
import 'package:new_nuntium/features/home/view/widgets/recent_news_card.dart';
import 'package:new_nuntium/features/home/view/widgets/recommended_news_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //Page Header
          SliverToBoxAdapter(
            child: Header(
              horizentalPadding: 20.w,
              title: AppStrings.homePageTitle,
              subTtitle: AppStrings.homePageSubTitle,
            ),
          ),

          //Search
          SliverToBoxAdapter(child: HomeSearchBar()),

          SliverPadding(padding: EdgeInsets.only(top: 24.h)),

          //News Categories
          const SliverToBoxAdapter(child: CategorySelector()),

          //Recent News
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 24.h),
              child: SizedBox(
                height: 256.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 20.w),
                  itemCount: controller.recentNews.length,
                  itemBuilder: (_, index) {
                    final news = controller.recentNews[index];

                    return RecentNewsCard(
                      news: news,
                      onTap: () => controller.onNewsCardPressed(news),
                      onBookmarkTap: () =>
                          controller.onNewsCardBookmarkPressed(news),
                    );
                  },
                ),
              ),
            ),
          ),

          SliverPadding(padding: EdgeInsets.only(top: 48.h)),

          _buildSectionHeader(context),

          // Recommended for you
          SliverList(
            delegate: SliverChildBuilderDelegate((_, index) {
              final news = controller.recommendedNews[index];
              return RecommendedNewsCard(
                news: news,
                margin: EdgeInsets.only(
                  right: 20.w,
                  left: 20.w,
                  bottom: 16.h,
                ),
                onTap: controller.onNewsCardPressed,
              );
            }, childCount: controller.recommendedNews.length),
          ),

          // إضافة مسافة في الأسفل لضمان عدم اختفاء الكروت خلف الـ BottomNavBar
          SliverToBoxAdapter(child: SizedBox(height: 80.h)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(
          right: 20.w,
          left: 20.w,
          bottom: 24.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.recommendedForYou,
              style: context.headline1.copyWith(fontSize: 20.sp),
            ),
            Text(
              AppStrings.seeAll,
              style: context.body1.copyWith(
                fontSize: 14.sp,
                color: AppColors.greyPrimary,
                fontWeight: AppFonts.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
