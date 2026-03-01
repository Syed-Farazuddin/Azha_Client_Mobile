import 'package:mobile/features/cart/data/models/cart_model.dart';

abstract class CartRepository {
  Future<CartModel?> getCart();
  Future<bool> addToCart(String productId, int quantity);
}
