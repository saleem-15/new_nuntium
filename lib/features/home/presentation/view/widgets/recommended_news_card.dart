import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/core/theme/app_fonts.dart';

class RecommendedArticleCard extends StatelessWidget {
  const RecommendedArticleCard({
    super.key,
    required this.article,
    required this.onTap,
    this.margin,
  });

  final Article article;
  final void Function(Article) onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap,
      child: Container(
        margin: margin,
        height: 96.h,
        child: SizedBox(
          width: ScreenUtil.defaultSize.width,
          child: Row(
            children: [
              //image
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: CachedNetworkImage(
                  width: 96.h,
                  height: 96.h,
                  imageUrl: article.imageUrl,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 500),
                  placeholder: (_, _) => Container(
                    color: AppColors.greyLighter,
                    child: const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                  errorWidget: (_, _, _) => Container(
                    color: AppColors.greyLighter,
                    child: const Icon(
                      Icons.broken_image,
                      color: AppColors.greyPrimary,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 16.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    // Article Category
                    Text(
                      article.category,
                      style: context.body1.copyWith(
                        fontSize: 14.sp,
                        fontWeight: AppFonts.regular,
                        color: AppColors.greyPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Article Title
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                      style: context.body1.copyWith(
                        color: AppColors.blackPrimary,
                        fontWeight: AppFonts.semiBold,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
