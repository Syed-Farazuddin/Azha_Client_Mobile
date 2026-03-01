import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/widgets/custom_button.dart';
import 'package:mobile/common/widgets/loading_indicator.dart';
import 'package:mobile/core/colors/app_colors.dart';
import 'package:mobile/core/constants/text_styles.dart';
import 'package:mobile/features/cart/domain/providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'My Cart',
          style: customTextStyles['sb20']?.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.dark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: cartAsync.when(
        data: (cart) {
          if (cart == null || cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: AppColors.blue500.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      size: 64.w,
                      color: AppColors.blue500,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Your cart is empty',
                    style: customTextStyles['sb20']?.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Looks like you haven't added anything yet.",
                    style: customTextStyles['r14']?.copyWith(
                      color: AppColors.subTitles,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  SizedBox(
                    width: 200.w,
                    child: CustomButton(
                      title: 'Start Shopping',
                      onPressed: () => context.go('/home'),
                    ),
                  ),
                ],
              ),
            );
          }

          double subtotal = cart.items.fold(
            0,
            (sum, item) => sum + (item.price * item.quantity),
          );
          const double deliveryFee = 49;
          final total = subtotal + deliveryFee;

          return Column(
            children: [
              // Items Count
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                color: AppColors.dark,
                child: Text(
                  '${cart.items.length} item${cart.items.length > 1 ? 's' : ''} in cart',
                  style: customTextStyles['r14']?.copyWith(
                    color: AppColors.subTitles,
                  ),
                ),
              ),
              // Cart Items List
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.dark,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.whitish),
                      ),
                      child: Row(
                        children: [
                          // Product Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: item.image.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: item.image,
                                    width: 90.w,
                                    height: 90.h,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => Container(
                                      width: 90.w,
                                      height: 90.h,
                                      color: AppColors.whitish,
                                    ),
                                    errorWidget: (_, __, ___) => Container(
                                      width: 90.w,
                                      height: 90.h,
                                      color: AppColors.whitish,
                                      child: const Icon(
                                        Icons.broken_image,
                                        color: AppColors.subTitles,
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 90.w,
                                    height: 90.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.whitish,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: const Icon(
                                      Icons.image,
                                      color: AppColors.subTitles,
                                    ),
                                  ),
                          ),
                          SizedBox(width: 14.w),
                          // Product Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: customTextStyles['sb14']?.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  '₹${item.price.toStringAsFixed(0)}',
                                  style: customTextStyles['sb16']?.copyWith(
                                    color: AppColors.blue500,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                // Quantity Controls
                                Row(
                                  children: [
                                    _buildQtyButton(
                                      icon: Icons.remove,
                                      onTap: () {
                                        // TODO: Decrement
                                      },
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 6.h,
                                      ),
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.whitish,
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                      ),
                                      child: Text(
                                        '${item.quantity}',
                                        style: customTextStyles['sb14']
                                            ?.copyWith(color: AppColors.white),
                                      ),
                                    ),
                                    _buildQtyButton(
                                      icon: Icons.add,
                                      onTap: () {
                                        // TODO: Increment
                                      },
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        // TODO: Remove item
                                      },
                                      child: Icon(
                                        Icons.delete_outline,
                                        color: AppColors.red500,
                                        size: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Bottom Checkout Section
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppColors.dark,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Offer Banner
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.green500.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.green500.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.local_offer,
                              color: AppColors.green500,
                              size: 18,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                'Free delivery on orders above ₹999!',
                                style: customTextStyles['r12']?.copyWith(
                                  color: AppColors.green500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildPriceRow('Subtotal', subtotal),
                      SizedBox(height: 8.h),
                      _buildPriceRow('Delivery Fee', deliveryFee),
                      SizedBox(height: 8.h),
                      Divider(color: AppColors.whitish),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: customTextStyles['sb18']?.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          Text(
                            '₹${total.toStringAsFixed(0)}',
                            style: customTextStyles['sb24']?.copyWith(
                              color: AppColors.blue500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      CustomButton(
                        title: 'Proceed to Checkout',
                        onPressed: () => context.go('/checkout'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppColors.red500),
              SizedBox(height: 16.h),
              Text(
                'Failed to load cart',
                style: customTextStyles['sb16']?.copyWith(
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 8.h),
              TextButton(
                onPressed: () =>
                    ref.read(cartNotifierProvider.notifier).fetchCart(),
                child: Text(
                  'Retry',
                  style: TextStyle(color: AppColors.blue500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQtyButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: AppColors.whitish,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: AppColors.subTitles.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: AppColors.white, size: 16),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: customTextStyles['r14']?.copyWith(color: AppColors.subTitles),
        ),
        Text(
          '₹${amount.toStringAsFixed(0)}',
          style: customTextStyles['sb14']?.copyWith(color: AppColors.white),
        ),
      ],
    );
  }
}
