import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/widgets/empty_state.dart';
import 'package:mobile/common/widgets/loading_indicator.dart';
import 'package:mobile/common/widgets/product_card.dart';
import 'package:mobile/core/colors/app_colors.dart';
import 'package:mobile/core/constants/text_styles.dart';
import 'package:mobile/features/products/domain/providers/product_provider.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResultsAsync = ref.watch(searchResultsProvider);
    final query = ref.watch(searchQueryProvider);

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
        title: TextField(
          autofocus: true,
          style: customTextStyles['r16']?.copyWith(color: AppColors.white),
          decoration: InputDecoration(
            hintText: 'Search for products...',
            hintStyle: customTextStyles['r16']?.copyWith(
              color: AppColors.subTitles,
            ),
            border: InputBorder.none,
            suffixIcon: query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: AppColors.subTitles),
                    onPressed: () {
                      ref.read(searchQueryProvider.notifier).state = '';
                    },
                  )
                : null,
          ),
          onChanged: (val) {
            ref.read(searchQueryProvider.notifier).state = val;
          },
        ),
      ),
      body: query.isEmpty
          ? Center(
              child: Text(
                'Type to search products',
                style: customTextStyles['sb16']?.copyWith(
                  color: AppColors.subTitles,
                ),
              ),
            )
          : searchResultsAsync.when(
              data: (products) {
                if (products.isEmpty) {
                  return const EmptyState(
                    icon: Icons.search_off,
                    title: 'No products found',
                    subtitle: 'Try searching with different keywords.',
                  );
                }
                return GridView.builder(
                  padding: EdgeInsets.all(16.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.60,
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
                      onTap: () => context.go('/product/${prod.id}'),
                    );
                  },
                );
              },
              loading: () => const Center(child: LoadingIndicator()),
              error: (err, stack) => Center(
                child: Text(
                  'Error: $err',
                  style: TextStyle(color: AppColors.red500),
                ),
              ),
            ),
    );
  }
}
