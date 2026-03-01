import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/home/data/models/category_model.dart';
import 'package:mobile/features/home/data/models/product_model.dart';
import 'package:mobile/features/home/data/repositories/home_repository_impl.dart';

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final repository = ref.read(homeRepositoryProvider);
  return repository.getCategories();
});

final productsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final repository = ref.read(homeRepositoryProvider);
  return repository.getProducts();
});

final suggestedProductsProvider = FutureProvider<List<ProductModel>>((
  ref,
) async {
  final repository = ref.read(homeRepositoryProvider);
  return repository.getSuggestedProducts();
});

final mostRatedProductsProvider = FutureProvider<List<ProductModel>>((
  ref,
) async {
  final repository = ref.read(homeRepositoryProvider);
  return repository.getMostRatedProducts();
});
