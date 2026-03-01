import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/network/urls.dart';
import 'package:mobile/features/cart/data/models/cart_model.dart';
import 'package:mobile/features/cart/domain/repositories/cart_repository.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  final apiClient = ref.read(apiClientServiceProvider);
  return CartRepositoryImpl(apiClient: apiClient);
});

class CartRepositoryImpl implements CartRepository {
  final ApiClientService apiClient;

  CartRepositoryImpl({required this.apiClient});

  @override
  Future<CartModel?> getCart() async {
    try {
      final response = await apiClient.get(NetworkUrls.getCart());
      if (response['success'] == true && response['cart'] != null) {
        return CartModel.fromJson(response['cart']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> addToCart(String productId, int quantity) async {
    try {
      final response = await apiClient.post(
        NetworkUrls.addToCart(productId),
        body: {'quantity': quantity},
      );
      return response['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
