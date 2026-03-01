import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/widgets/loading_indicator.dart';
import 'package:mobile/common/widgets/product_card.dart';
import 'package:mobile/core/colors/app_colors.dart';
import 'package:mobile/core/constants/text_styles.dart';
import 'package:mobile/features/home/domain/providers/home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final productsAsync = ref.watch(productsProvider);
    final suggestedAsync = ref.watch(suggestedProductsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'AZHA',
          style: customTextStyles['sb24']?.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.dark,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.white),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.white,
            ),
            onPressed: () => context.push('/cart'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.white),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            // Header Offers
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.purple,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Super Sale\nUp to 50% Off',
                          style: customTextStyles['b24']?.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: const Text('Shop Now'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Categories
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Categories',
                style: customTextStyles['sb18']?.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 100.h,
              child: categoriesAsync.when(
                data: (categories) {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (context, index) => SizedBox(width: 16.w),
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      return Column(
                        children: [
                          CircleAvatar(
                            radius: 30.r,
                            backgroundColor: AppColors.whitish,
                            backgroundImage: cat.image.isNotEmpty
                                ? NetworkImage(cat.image)
                                : null,
                            child: cat.image.isEmpty
                                ? const Icon(
                                    Icons.category,
                                    color: AppColors.subTitles,
                                  )
                                : null,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            cat.name,
                            style: customTextStyles['r12']?.copyWith(
                              color: AppColors.subTitles,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                loading: () => const LoadingIndicator(),
                error: (err, stack) => Center(
                  child: Text(
                    'Error loading categories',
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Suggested Products
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Suggested For You',
                style: customTextStyles['sb18']?.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 290.h,
              child: suggestedAsync.when(
                data: (products) {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    separatorBuilder: (context, index) => SizedBox(width: 16.w),
                    itemBuilder: (context, index) {
                      final prod = products[index];
                      return ProductCard(
                        imageUrl: prod.image ?? '',
                        title: prod.title,
                        price: prod.price,
                        originalPrice: prod.originalPrice,
                        rating: prod.rating,
                        reviewCount: prod.numReviews,
                        onTap: () => context.push('/product/${prod.id}'),
                      );
                    },
                  );
                },
                loading: () => const LoadingIndicator(),
                error: (err, stack) => Center(
                  child: Text(
                    'Error loading suggested',
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // All Products Grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'All Products',
                style: customTextStyles['sb18']?.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            productsAsync.when(
              data: (products) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio: 0.60, // Adjusted to fit image and text
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final prod = products[index];
                      return ProductCard(
                        imageUrl: prod.image ?? '',
                        title: prod.title,
                        price: prod.price,
                        originalPrice: prod.originalPrice,
                        rating: prod.rating,
                        reviewCount: prod.numReviews,
                        onTap: () => context.push('/product/${prod.id}'),
                      );
                    },
                  ),
                );
              },
              loading: () => const LoadingIndicator(),
              error: (err, stack) => Center(
                child: Text(
                  'Error loading products',
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
