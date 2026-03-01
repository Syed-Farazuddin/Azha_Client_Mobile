import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/colors/app_colors.dart';
import 'package:mobile/core/constants/text_styles.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionButton,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? actionButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.blue50.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 64.w, color: AppColors.blue500),
            ),
            SizedBox(height: 24.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: customTextStyles['sb20']?.copyWith(color: AppColors.black),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: customTextStyles['r14']?.copyWith(
                color: AppColors.subTitles,
                height: 1.5,
              ),
            ),
            if (actionButton != null) ...[
              SizedBox(height: 32.h),
              actionButton!,
            ],
          ],
        ),
      ),
    );
  }
}
