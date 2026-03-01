import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/colors/app_colors.dart';
import 'package:mobile/core/constants/text_styles.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.originalPrice,
    this.rating,
    this.reviewCount,
    required this.onTap,
  });

  final String imageUrl;
  final String title;
  final double price;
  final double? originalPrice;
  final double? rating;
  final int? reviewCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160.w,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: 180.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  height: 180.h,
                  color: AppColors.baseLight,
                  child: const Icon(
                    Icons.broken_image,
                    color: AppColors.subTitles,
                  ),
                ),
                placeholder: (context, url) => Container(
                  height: 180.h,
                  color: AppColors.baseLight,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: customTextStyles['sb14']?.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  // Price section
                  Row(
                    children: [
                      Text(
                        '₹${price.toStringAsFixed(0)}',
                        style:
                            customTextStyles['sb16']?.copyWith(
                              color: AppColors.blue500,
                            ) ??
                            TextStyle(
                              color: AppColors.blue500,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (originalPrice != null) ...[
                        SizedBox(width: 6.w),
                        Text(
                          '₹${originalPrice!.toStringAsFixed(0)}',
                          style: customTextStyles['r12']?.copyWith(
                            color: AppColors.subTitles,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 6.h),
                  // Rating section
                  if (rating != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.orange300,
                          size: 14,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          rating!.toStringAsFixed(1),
                          style: customTextStyles['sb12']?.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                        if (reviewCount != null) ...[
                          SizedBox(width: 4.w),
                          Text(
                            '($reviewCount)',
                            style: customTextStyles['r12']?.copyWith(
                              color: AppColors.subTitles,
                            ),
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
