import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/network/urls.dart';
import 'package:mobile/features/home/data/models/category_model.dart';
import 'package:mobile/features/home/data/models/product_model.dart';
import 'package:mobile/features/home/domain/repositories/home_repository.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final apiClient = ref.read(apiClientServiceProvider);
  return HomeRepositoryImpl(apiClient: apiClient);
});

class HomeRepositoryImpl implements HomeRepository {
  final ApiClientService apiClient;

  HomeRepositoryImpl({required this.apiClient});

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await apiClient.get(NetworkUrls.listCategories());
      if (response['success'] == true) {
        return (response['categories'] as List)
            .map((e) => CategoryModel.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await apiClient.get(NetworkUrls.listProducts());
      if (response['sucess'] == true || response['success'] == true) {
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
  Future<List<ProductModel>> getSuggestedProducts() async {
    try {
      final response = await apiClient.get(NetworkUrls.suggestedProducts());
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
  Future<List<ProductModel>> getMostRatedProducts() async {
    try {
      final response = await apiClient.get(NetworkUrls.mostRatedProducts());
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
}
