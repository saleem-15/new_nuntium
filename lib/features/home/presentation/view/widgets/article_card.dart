import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/core/constants/app_assets.dart';
import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/core/theme/app_fonts.dart';
import 'package:new_nuntium/core/theme/app_text_styles.dart';
import 'package:new_nuntium/features/home/presentation/controller/home_controller.dart';

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
    // تحديد مصدر الصورة (شبكة أو عنصر نائب)
    final ImageProvider imageProvider = (article.imageUrl.isEmpty)
        ? const AssetImage(AppAssets.newsPlaceholder)
        : CachedNetworkImageProvider(article.imageUrl) as ImageProvider;

    return Container(
      width: 336.w, // استخدام ScreenUtil
      alignment: Alignment.center,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: AppColors.white, // ضمان وجود لون خلفية
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
            /// Article Card Image
            SizedBox(
              width: double.infinity,
              height: 192.h,
              child: Image(
                image: imageProvider,
                fit: BoxFit.cover,
                // في حالة فشل تحميل صورة الشبكة، نعرض الـ Placeholder
                errorBuilder: (_, _, _) =>
                    Image.asset(AppAssets.newsPlaceholder, fit: BoxFit.cover),
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
