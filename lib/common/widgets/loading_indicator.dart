import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile/core/colors/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.color = AppColors.blue500,
    this.size = 40.0,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingCircle(color: color, size: size),
    );
  }
}

class OverlayLoadingIndicator extends StatelessWidget {
  const OverlayLoadingIndicator({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: AppColors.black.withOpacity(0.3),
            child: const Center(
              child: SpinKitFadingCircle(color: AppColors.blue500, size: 50.0),
            ),
          ),
      ],
    );
  }
}
