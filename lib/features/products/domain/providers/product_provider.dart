import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/home/data/models/product_model.dart';
import 'package:mobile/features/products/data/repositories/product_repository_impl.dart';

// Provider to get Product details by ID
final productDetailsProvider = FutureProvider.family<ProductModel?, String>((
  ref,
  id,
) async {
  final repository = ref.read(productRepositoryProvider);
  return repository.getProductById(id);
});

// Search State Provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Provider to search products automatically when query changes
final searchResultsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];

  // Optionally debounce logic here, but for simplicity, we directly fetch
  final repository = ref.read(productRepositoryProvider);
  return repository.searchProducts(query);
});
