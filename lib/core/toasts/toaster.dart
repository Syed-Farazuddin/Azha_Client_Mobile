import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/common/styles/box_styles.dart';
import 'package:mobile/common/widgets/server_text.dart';
import 'package:mobile/core/colors/app_colors.dart';
import 'package:mobile/gen/assets.gen.dart';
import 'package:toastification/toastification.dart';

const _duration = Duration(seconds: 1);

class Toaster {
  static void onSuccess({
    String? message,
    Widget? icon,
    Color? textColor,
    Color? backgroundColor,
    List<Widget>? actions,
    String? description,
  }) {
    custom(
      textColor: Colors.black,
      backgroundColor: AppColors.white,
      message: message,
      actions: actions,
      icon: icon,
      description: description,
    );
  }

  static void onInfo(
    String? message, {
    Widget? icon,
    String? description,
    bool autoClose = false,
    List<Widget>? actions,
  }) {
    custom(
      type: ToastificationType.info,
      textColor: Colors.black,
      backgroundColor: AppColors.greyCaption,
      message: message,
      actions: actions,
      icon: icon,
      description: description,
    );
  }

  static void onWarning(
    String? message, {
    Widget? icon,
    String? description,
    bool autoClose = false,
    List<Widget>? actions,
  }) {
    custom(
      type: ToastificationType.warning,
      textColor: Colors.black,
      backgroundColor: AppColors.white,
      message: message,
      actions: actions,
      icon: icon,
      description: description,
    );
  }

  static void onError({
    String? message,
    Widget? icon,
    String? description,
    bool autoClose = false,
    List<Widget>? actions,
    Duration? duration,
  }) {
    custom(
      customDuration: duration,
      type: ToastificationType.error,
      textColor: Colors.black,
      backgroundColor: AppColors.white,
      message: message,
      actions: actions,
      icon: icon,
      description: description,
    );
  }

  static void custom({
    String? message,
    Duration? customDuration,
    Widget? icon,
    Color? textColor,
    String? description,
    Color? backgroundColor,
    ToastificationType type = ToastificationType.success,
    List<Widget>? actions,
  }) {
    _customToast(
      backgroundColor,
      textColor,
      customDuration,
      message,
      actions,
      icon,
      type: type,
      description: description,
    );
  }

  static void _customToast(
    Color? backgroundColor,
    Color? textColor,
    Duration? customDuration,
    String? message,
    List<Widget>? actions,
    Widget? icon, {
    bool autoClose = true,
    String? description,
    ToastificationType type = ToastificationType.success,
  }) {
    toastification.showCustom(
      builder: (context, _) => Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
        child: Container(
          width: double.infinity,
          decoration: BoxStyle.cornedSmoothedSemiContainerDecoration(
            color: backgroundColor ?? Colors.black,
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: backgroundColor ?? Colors.black),
            smoothBorderRadius: SmoothBorderRadius.all(
              SmoothRadius(cornerRadius: 8.r, cornerSmoothing: 0.9),
            ),
          ),
          padding: EdgeInsets.all(12.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (icon != null)
                      icon
                    else
                      type == ToastificationType.success
                          ? SvgPicture.asset(
                              Assets.svgs.greenTick,
                              width: 20.r,
                              height: 20.r,
                            )
                          : type == ToastificationType.warning ||
                                type == ToastificationType.info
                          ? const Icon(
                              Icons.warning,
                              size: 20,
                              color: Colors.yellow,
                            )
                          : SvgPicture.asset(
                              Assets.svgs.error,
                              width: 20.r,
                              height: 20.r,
                            ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: ServerText(
                        message ?? description ?? '',
                        additionalStyle: TextStyle(
                          color: textColor ?? Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ...actions ?? [],
            ],
          ),
        ),
      ),
      animationBuilder: (context, animation, alignment, child) =>
          FadeTransition(opacity: animation, child: child),
      autoCloseDuration: autoClose ? customDuration ?? _duration : null,
    );
  }
}
