import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/core/resources/app_assets.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/core/theme/app_fonts.dart';
import 'package:new_nuntium/core/theme/app_text_styles.dart';
import 'package:new_nuntium/features/home/presentation/controller/home_controller.dart';
import 'package:shimmer/shimmer.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback? onBookmarkPressed;
  final VoidCallback? onPressed;

  const ArticleCard({
    super.key,
    required this.article,
    required this.onBookmarkPressed,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 336.w, 
      alignment: Alignment.center,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: AppColors.white, 
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(width: 1.w, color: AppColors.greyLighter),
      ),
      child: MaterialButton(
        splashColor: AppColors.greyLight.withValues(alpha: .1),
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 192.h,
              child: article.imageUrl.isEmpty
                  ? Image.asset(AppAssets.newsPlaceholder, fit: BoxFit.cover)
                  : CachedNetworkImage(
                      imageUrl: article.imageUrl,
                      fit: BoxFit.cover,
                      //Fade In
                      fadeInDuration: const Duration(milliseconds: 500),

                      // Shimmer Effect
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.white,
                        ),
                      ),

                      errorWidget: (context, url, error) => Image.asset(
                        AppAssets.newsPlaceholder,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),

            /// Article Card Text + Icon
            SizedBox(
              height: 80.h,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                child: Row(
                  children: [
                    /// Article Title
                    Expanded(
                      child: Text(
                        article.title, // استخدام title بدلاً من displayText
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyText2.copyWith(
                          fontWeight: AppFonts.semiBold,
                          color: AppColors.blackPrimary,
                        ),
                      ),
                    ),

                    /// Bookmark Icon (Reactive)
                    GetBuilder<HomeController>(
                      id: article.id,
                      builder: (_) {
                        return IconButton(
                          onPressed: onBookmarkPressed,
                          icon: SvgPicture.asset(
                            article.isSaved
                                ? AppIcons.bookmarkFilled
                                : AppIcons.bookmark,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
