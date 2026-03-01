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
import 'package:mobile/features/products/domain/providers/product_provider.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  const ProductDetailsScreen({super.key, required this.productId});
  final String productId;

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailsProvider(widget.productId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: productAsync.when(
        data: (product) {
          if (product == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.red500),
                  SizedBox(height: 16.h),
                  Text(
                    'Product not found.',
                    style: customTextStyles['sb18']?.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      'Go Back',
                      style: TextStyle(color: AppColors.blue500),
                    ),
                  ),
                ],
              ),
            );
          }

          final discountPercent =
              product.originalPrice != null &&
                  product.originalPrice! > product.price
              ? (((product.originalPrice! - product.price) /
                            product.originalPrice!) *
                        100)
                    .round()
              : 0;

          return CustomScrollView(
            slivers: [
              // Image Carousel with App Bar
              SliverAppBar(
                expandedHeight: 420.h,
                pinned: true,
                backgroundColor: AppColors.dark,
                leading: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    margin: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.white,
                      size: 18,
                    ),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () => context.push('/cart'),
                    child: Container(
                      margin: EdgeInsets.all(8.w),
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: AppColors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // Image PageView
                      PageView.builder(
                        controller: _pageController,
                        itemCount: product.images.length,
                        onPageChanged: (index) {
                          setState(() => _currentImageIndex = index);
                        },
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            imageUrl: product.images[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (context, url) => Container(
                              color: AppColors.whitish,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppColors.whitish,
                              child: const Icon(
                                Icons.broken_image,
                                color: AppColors.subTitles,
                                size: 48,
                              ),
                            ),
                          );
                        },
                      ),
                      // Image Indicator
                      if (product.images.length > 1)
                        Positioned(
                          bottom: 16.h,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              product.images.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: EdgeInsets.symmetric(horizontal: 3.w),
                                width: _currentImageIndex == index ? 24.w : 8.w,
                                height: 8.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.r),
                                  color: _currentImageIndex == index
                                      ? AppColors.white
                                      : AppColors.white.withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      // Discount Badge
                      if (discountPercent > 0)
                        Positioned(
                          top: 100.h,
                          left: 16.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.red500,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              '$discountPercent% OFF',
                              style: customTextStyles['sb12']?.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Product Info Section
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Tag
                      if (product.categoryName != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.blue500.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            product.categoryName!,
                            style: customTextStyles['sb12']?.copyWith(
                              color: AppColors.blue500,
                            ),
                          ),
                        ),
                      SizedBox(height: 12.h),

                      // Title
                      Text(
                        product.title,
                        style: customTextStyles['sb24']?.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Bio / Subtitle
                      if (product.bio != null)
                        Text(
                          product.bio!,
                          style: customTextStyles['r14']?.copyWith(
                            color: AppColors.subTitles,
                            height: 1.4,
                          ),
                        ),
                      SizedBox(height: 16.h),

                      // Price Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${product.price.toStringAsFixed(0)}',
                            style: customTextStyles['b24']?.copyWith(
                              color: AppColors.blue500,
                            ),
                          ),
                          if (product.originalPrice != null) ...[
                            SizedBox(width: 10.w),
                            Text(
                              '₹${product.originalPrice!.toStringAsFixed(0)}',
                              style: customTextStyles['r16']?.copyWith(
                                color: AppColors.subTitles,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            if (product.discount != null)
                              Text(
                                'Save ₹${product.discount!.toStringAsFixed(0)}',
                                style: customTextStyles['sb14']?.copyWith(
                                  color: AppColors.green500,
                                ),
                              ),
                          ],
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Rating Row
                      if (product.rating != null)
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.green500,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    product.rating!.toStringAsFixed(1),
                                    style: customTextStyles['sb12']?.copyWith(
                                      color: AppColors.white,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  const Icon(
                                    Icons.star,
                                    color: AppColors.white,
                                    size: 12,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                      SizedBox(height: 24.h),
                      Divider(color: AppColors.whitish, thickness: 1),
                      SizedBox(height: 24.h),

                      // Description Section
                      Text(
                        'Description',
                        style: customTextStyles['sb18']?.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        product.description ?? 'No description available.',
                        style: customTextStyles['r16']?.copyWith(
                          color: AppColors.normalText,
                          height: 1.6,
                        ),
                      ),

                      // Review Section
                      if (product.reviewTitle != null ||
                          product.reviewDescription != null) ...[
                        SizedBox(height: 24.h),
                        Divider(color: AppColors.whitish, thickness: 1),
                        SizedBox(height: 24.h),
                        Text(
                          'Customer Review',
                          style: customTextStyles['sb18']?.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: AppColors.whitish,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (product.reviewRating != null) ...[
                                    ...List.generate(
                                      5,
                                      (i) => Icon(
                                        i < product.reviewRating!.round()
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: AppColors.orange300,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                  ],
                                  Expanded(
                                    child: Text(
                                      product.reviewTitle ?? '',
                                      style: customTextStyles['sb14']?.copyWith(
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                product.reviewDescription ?? '',
                                style: customTextStyles['r14']?.copyWith(
                                  color: AppColors.subTitles,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Image Gallery (Thumbnails)
                      if (product.images.length > 1) ...[
                        SizedBox(height: 24.h),
                        Divider(color: AppColors.whitish, thickness: 1),
                        SizedBox(height: 24.h),
                        Text(
                          'More Images',
                          style: customTextStyles['sb18']?.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        SizedBox(
                          height: 80.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: product.images.length,
                            separatorBuilder: (_, __) => SizedBox(width: 12.w),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  _pageController.animateToPage(
                                    index,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Container(
                                  width: 80.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: _currentImageIndex == index
                                          ? AppColors.blue500
                                          : AppColors.whitish,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6.r),
                                    child: CachedNetworkImage(
                                      imageUrl: product.images[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],

                      // Bottom spacer for bottom sheet
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: TextStyle(color: AppColors.red500)),
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.dark,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.2),
              offset: const Offset(0, -4),
              blurRadius: 12,
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  title: 'Add to Cart',
                  hasBorder: true,
                  borderColor: AppColors.blue500,
                  textColor: AppColors.blue500,
                  backgroundColor: AppColors.transparent,
                  onPressed: () async {
                    await ref
                        .read(cartNotifierProvider.notifier)
                        .addToCart(widget.productId, 1);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Added to cart!'),
                          backgroundColor: AppColors.green500,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: CustomButton(
                  title: 'Buy Now',
                  onPressed: () {
                    context.go('/checkout');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
