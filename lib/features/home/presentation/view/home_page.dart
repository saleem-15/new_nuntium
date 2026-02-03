import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/core/widgets/header.dart';
import 'package:new_nuntium/features/home/presentation/controller/home_controller.dart';
import 'package:new_nuntium/features/home/presentation/view/widgets/article_card.dart';
import 'package:new_nuntium/features/home/presentation/view/widgets/articles_loading_error.dart';
import 'package:new_nuntium/features/home/presentation/view/widgets/articles_loading_indicator.dart';
import 'package:new_nuntium/features/home/presentation/view/widgets/category_selector.dart';
import 'package:new_nuntium/features/home/presentation/view/widgets/home_search_bar.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        floatingActionButton: Obx(() {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: controller.showScrollUpButton.value ? 1.0 : 0.0,
            child: Visibility(
              visible: controller.showScrollUpButton.value,
              child: FloatingActionButton(
                onPressed: controller.scrollToTop,
                backgroundColor: AppColors.purplePrimary,
                mini: true,
                child: const Icon(Icons.arrow_upward, color: Colors.white),
              ),
            ),
          );
        }),

        body: CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            // Page Header
            SliverToBoxAdapter(
              child: Header(
                horizentalPadding: 20.w,
                title: AppStrings.homePageTitle,
                subTtitle: AppStrings.homePageSubTitle,
              ),
            ),

            // Search
            SliverToBoxAdapter(
              child: HomeSearchBar(
                searchFieldController: controller.searchFieldController,
                onSearchPressed: controller.search,
              ),
            ),

            SliverPadding(padding: EdgeInsets.only(top: 24.h)),

            // News Categories
            const SliverToBoxAdapter(child: CategorySelector()),

            SliverPadding(padding: EdgeInsets.only(top: 24.h)),

            PagingListener(
              controller: controller.pagingController,
              builder: (context, state, fetchNextPage) {
                return PagedSliverList<int, Article>(
                  // لاحظ: نمرر state و fetchNextPage بدلاً من controller
                  state: state,
                  fetchNextPage: fetchNextPage,

                  builderDelegate: PagedChildBuilderDelegate<Article>(
                    animateTransitions: true,

                    // بناء العنصر
                    itemBuilder: (context, article, index) => Padding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: Center(
                        key: ValueKey(article.id), // مهم للأداء
                        child: ArticleCard(
                          article: article,
                          onPressed: () =>
                              controller.onArticleCardPressed(article),
                          onBookmarkPressed: () =>
                              controller.onArticleBookmarkPressed(article),
                        ),
                      ),
                    ),

                    // حالة عدم وجود بيانات
                    noItemsFoundIndicatorBuilder: (_) =>
                        Center(child: Text(AppStrings.noArticlesFound)),

                    // حالة الخطأ في الصفحة الأولى
                    firstPageErrorIndicatorBuilder: (_) => PageLoadingError(
                      onRefreshPressed: controller.onRefreshPressed,
                    ),

                    // مؤشر التحميل الأولي
                    firstPageProgressIndicatorBuilder: (_) =>
                        const ArticlesLoadingIndicator(),

                    // مؤشر تحميل صفحة جديدة
                    newPageProgressIndicatorBuilder: (_) => const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    ),
                  ),
                );
              },
            ),

            // //Recent News
            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding: EdgeInsets.only(top: 24.h),
            //     child: SizedBox(
            //       height: 256.h,
            //       child: ListView.builder(
            //         scrollDirection: Axis.horizontal,
            //         padding: EdgeInsets.only(left: 20.w),
            //         itemCount: controller.recentNews.length,
            //         itemBuilder: (_, index) {
            //           final news = controller.recentNews[index];

            //           return RecentNewsCard(
            //             news: news,
            //             onTap: () => controller.onNewsCardPressed(news),
            //             onBookmarkTap: () =>
            //                 controller.onNewsCardBookmarkPressed(news),
            //           );
            //         },
            //       ),
            //     ),
            //   ),
            // ),

            // SliverPadding(padding: EdgeInsets.only(top: 48.h)),

            // _buildRecommendedSectionHeader(context),

            // //Recommended for you
            // SliverList(
            //   delegate: SliverChildBuilderDelegate((_, index) {
            //     final news = controller.recommendedNews[index];
            //     return RecommendedNewsCard(
            //       news: news,
            //       margin: EdgeInsets.only(right: 20.w, left: 20.w, bottom: 16.h),
            //       onTap: controller.onNewsCardPressed,
            //     );
            //   }, childCount: controller.recommendedNews.length),
            // ),

            // إضافة مسافة في الأسفل لضمان عدم اختفاء الكروت خلف الـ BottomNavBar
            SliverToBoxAdapter(child: SizedBox(height: 80.h)),
          ],
        ),
      ),
    );
  }

  // Widget _buildRecommendedSectionHeader(BuildContext context) {
  //   return SliverToBoxAdapter(
  //     child: Padding(
  //       padding: EdgeInsets.only(right: 20.w, left: 20.w, bottom: 24.h),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             AppStrings.recommendedForYou,
  //             style: context.headline1.copyWith(fontSize: 20.sp),
  //           ),
  //           Text(
  //             AppStrings.seeAll,
  //             style: context.body1.copyWith(
  //               fontSize: 14.sp,
  //               color: AppColors.greyPrimary,
  //               fontWeight: AppFonts.medium,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
