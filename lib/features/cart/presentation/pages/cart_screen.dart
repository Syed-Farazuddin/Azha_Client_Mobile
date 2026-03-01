import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/widgets/cart_item_card.dart';
import 'package:mobile/common/widgets/custom_button.dart';
import 'package:mobile/common/widgets/empty_state.dart';
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
          'Your Cart',
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
            return EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'Your cart is empty',
              subtitle: 'Looks like you haven\'t added anything yet.',
              actionButton: CustomButton(
                title: 'Start Shopping',
                onPressed: () => context.go('/home'),
              ),
            );
          }

          double total = cart.items.fold(
            0,
            (sum, item) => sum + (item.price * item.quantity),
          );

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: cart.items.length,
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return CartItemCard(
                      imageUrl: item.image,
                      title: item.title,
                      price: item.price,
                      quantity: item.quantity,
                      onIncrement: () {}, // Implementation pending
                      onDecrement: () {}, // Implementation pending
                      onRemove: () {}, // Implementation pending
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: customTextStyles['sb16']?.copyWith(
                              color: AppColors.subTitles,
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
                      SizedBox(height: 20.h),
                      CustomButton(
                        title: 'Proceed to Checkout',
                        onPressed: () {
                          context.go('/checkout');
                        },
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
          child: Text('Error: $err', style: TextStyle(color: AppColors.white)),
        ),
      ),
    );
  }
}
