import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/colors/app_colors.dart';
import 'package:mobile/core/constants/text_styles.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final String imageUrl;
  final String title;
  final double price;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 80.w,
              height: 80.w,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Container(
                width: 80.w,
                height: 80.w,
                color: AppColors.baseLight,
                child: const Icon(
                  Icons.broken_image,
                  color: AppColors.subTitles,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: customTextStyles['sb14']?.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: onRemove,
                      child: const Icon(
                        Icons.delete_outline,
                        color: AppColors.red500,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  '₹${price.toStringAsFixed(0)}',
                  style: customTextStyles['sb16']?.copyWith(
                    color: AppColors.blue500,
                  ),
                ),
                SizedBox(height: 8.h),
                // Quantity controls
                Row(
                  children: [
                    _buildQuantityButton(
                      icon: Icons.remove,
                      onTap: onDecrement,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      quantity.toString(),
                      style: customTextStyles['sb14']?.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    _buildQuantityButton(icon: Icons.add, onTap: onIncrement),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppColors.baseLight,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: AppColors.subTitles.withOpacity(0.3)),
        ),
        child: Icon(icon, size: 16.w, color: AppColors.black),
      ),
    );
  }
}
