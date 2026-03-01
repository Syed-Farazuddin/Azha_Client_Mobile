import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/widgets/custom_button.dart';
import 'package:mobile/common/widgets/loading_indicator.dart';
import 'package:mobile/core/colors/app_colors.dart';
import 'package:mobile/core/constants/text_styles.dart';
import 'package:mobile/features/products/domain/providers/product_provider.dart';

class ProductDetailsScreen extends ConsumerWidget {
  const ProductDetailsScreen({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailsProvider(productId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.white,
            ),
            onPressed: () => context.go('/cart'),
          ),
        ],
      ),
      body: productAsync.when(
        data: (product) {
          if (product == null) {
            return const Center(
              child: Text(
                'Product not found.',
                style: TextStyle(color: AppColors.white),
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  width: double.infinity,
                  height: 350.h,
                  color: AppColors.baseLight,
                  child: CachedNetworkImage(
                    imageUrl: product.image ?? '',
                    fit: BoxFit.cover,
                    errorWidget: (context, url, err) =>
                        const Icon(Icons.image_not_supported),
                  ),
                ),
                SizedBox(height: 24.h),
                // Product Details
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(color: AppColors.background),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: customTextStyles['sb24']?.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Text(
                            '₹${product.price.toStringAsFixed(0)}',
                            style: customTextStyles['b24']?.copyWith(
                              color: AppColors.blue500,
                            ),
                          ),
                          if (product.originalPrice != null) ...[
                            SizedBox(width: 8.w),
                            Text(
                              '₹${product.originalPrice?.toStringAsFixed(0)}',
                              style: customTextStyles['r16']?.copyWith(
                                color: AppColors.subTitles,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 16.h),
                      if (product.rating != null)
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppColors.orange300,
                              size: 20,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              product.rating!.toStringAsFixed(1),
                              style: customTextStyles['sb16']?.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                            if (product.numReviews != null) ...[
                              SizedBox(width: 6.w),
                              Text(
                                '(${product.numReviews} Reviews)',
                                style: customTextStyles['r14']?.copyWith(
                                  color: AppColors.subTitles,
                                ),
                              ),
                            ],
                          ],
                        ),
                      SizedBox(height: 32.h),
                      Text(
                        'Description',
                        style: customTextStyles['sb18']?.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'This is a sample description for the product. It features premium materials and exceptional craftsmanship. Perfect for your specific ecommerce needs.',
                        style: customTextStyles['r16']?.copyWith(
                          color: AppColors.normalText,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 120.h),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: TextStyle(color: AppColors.red500)),
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.dark,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.1),
              offset: const Offset(0, -4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                title: 'Add to Cart',
                hasBorder: true,
                borderColor: AppColors.blue500,
                textColor: AppColors.blue500,
                backgroundColor: AppColors.transparent,
                onPressed: () {
                  // TODO: Add to cart
                },
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: CustomButton(
                title: 'Buy Now',
                onPressed: () {
                  // TODO: Go to checkout
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
