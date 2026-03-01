import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/widgets/custom_button.dart';
import 'package:mobile/common/widgets/loading_indicator.dart';
import 'package:mobile/core/colors/app_colors.dart';
import 'package:mobile/core/constants/text_styles.dart';
import 'package:mobile/features/orders/domain/providers/order_provider.dart';

class OrderConfirmationScreen extends ConsumerWidget {
  const OrderConfirmationScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailsProvider(orderId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: orderAsync.when(
        data: (order) {
          if (order == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.red500,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Order not found',
                    style: customTextStyles['sb20']?.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  CustomButton(
                    title: 'Go Home',
                    onPressed: () => context.go('/home'),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: AppColors.green500.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      size: 80,
                      color: AppColors.green500,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    'Order Confirmed!',
                    style: customTextStyles['sb24']?.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Thank you for your purchase. Your order has been placed successfully.',
                    textAlign: TextAlign.center,
                    style: customTextStyles['r16']?.copyWith(
                      color: AppColors.subTitles,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppColors.dark,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order ID:',
                              style: customTextStyles['r14']?.copyWith(
                                color: AppColors.subTitles,
                              ),
                            ),
                            Text(
                              order.id,
                              style: customTextStyles['sb14']?.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Amount:',
                              style: customTextStyles['r14']?.copyWith(
                                color: AppColors.subTitles,
                              ),
                            ),
                            Text(
                              '₹${order.totalPrice.toStringAsFixed(0)}',
                              style: customTextStyles['sb14']?.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),
                  CustomButton(
                    title: 'Continue Shopping',
                    onPressed: () => context.go('/home'),
                  ),
                  SizedBox(height: 16.h),
                  CustomButton(
                    title: 'View Orders',
                    hasBorder: true,
                    borderColor: AppColors.blue500,
                    backgroundColor: AppColors.transparent,
                    textColor: AppColors.blue500,
                    onPressed: () {
                      // Navigate to Profile/Orders
                    },
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (err, stack) => Center(
          child: Text(
            'Error loading order',
            style: TextStyle(color: AppColors.red500),
          ),
        ),
      ),
    );
  }
}
