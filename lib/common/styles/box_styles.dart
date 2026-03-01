import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BoxStyle {
  static ShapeDecoration cornedSmoothedContainerDecoration({
    Color? color,
    Color? borderColor,
    double? borderRadius,
    Gradient? gradient,
    double? borderWidth,
  }) => ShapeDecoration(
    color: gradient == null && color != null ? color : null,
    gradient: gradient,
    shape: SmoothRectangleBorder(
      side: borderColor != null
          ? BorderSide(color: borderColor, width: borderWidth ?? 1.w)
          : BorderSide.none,
      borderRadius: SmoothBorderRadius(
        cornerRadius: borderRadius ?? 12.r,
        cornerSmoothing: 0.8,
      ),
    ),
  );

  static ShapeDecoration cornedSmoothedSemiContainerDecoration({
    Color? color,
    BorderRadius? borderRadius,
    Gradient? gradient,
    BorderSide? borderSide,
    SmoothBorderRadius? smoothBorderRadius,
  }) => ShapeDecoration(
    color: gradient == null && color != null ? color : null,
    gradient: gradient,
    shape: SmoothRectangleBorder(
      side: borderSide ?? BorderSide.none,
      borderRadius: smoothBorderRadius ?? SmoothBorderRadius.zero,
    ),
  );
}
