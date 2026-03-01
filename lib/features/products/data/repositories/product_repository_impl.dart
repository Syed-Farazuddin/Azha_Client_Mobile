import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/network/urls.dart';
import 'package:mobile/features/home/data/models/product_model.dart';
import 'package:mobile/features/products/domain/repositories/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final apiClient = ref.read(apiClientServiceProvider);
  return ProductRepositoryImpl(apiClient: apiClient);
});

class ProductRepositoryImpl implements ProductRepository {
  final ApiClientService apiClient;

  ProductRepositoryImpl({required this.apiClient});

  @override
  Future<ProductModel?> getProductById(String id) async {
    try {
      final response = await apiClient.get(NetworkUrls.getProductById(id));
      // API returns the product object directly at the root level
      if (response != null && response['id'] != null) {
        return ProductModel.fromJson(response);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await apiClient.get(NetworkUrls.searchProducts(query));
      if (response['success'] == true) {
        return (response['products'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> addReview(
    String productId,
    String title,
    String description,
    double rating,
  ) async {
    try {
      final response = await apiClient.post(
        NetworkUrls.addReview(productId),
        body: {
          'title': title,
          'description': description,
          'rating': rating,
          'images': [],
        },
      );
      return response['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
