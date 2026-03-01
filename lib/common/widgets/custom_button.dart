import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile/core/colors/app_colors.dart';
import 'package:mobile/core/constants/text_styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor = AppColors.blue500,
    this.textColor = AppColors.white,
    this.hasBorder = false,
    this.borderColor = AppColors.blue500,
    this.icon,
    this.width,
    this.height,
  });

  final String title;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final bool hasBorder;
  final Color borderColor;
  final Widget? icon;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 56.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: hasBorder ? Colors.transparent : backgroundColor,
          foregroundColor: textColor,
          elevation: hasBorder ? 0 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: hasBorder
                ? BorderSide(color: borderColor, width: 1.5)
                : BorderSide.none,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
        child: isLoading
            ? const SpinKitThreeBounce(color: AppColors.white, size: 24)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[icon!, SizedBox(width: 8.w)],
                  Text(
                    title,
                    style:
                        customTextStyles['sb16']?.copyWith(color: textColor) ??
                        TextStyle(
                          color: textColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
      ),
    );
  }
}
