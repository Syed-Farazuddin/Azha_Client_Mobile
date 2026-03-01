import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/cart/data/models/cart_model.dart';
import 'package:mobile/features/cart/data/repositories/cart_repository_impl.dart';

final cartProvider = FutureProvider<CartModel?>((ref) async {
  final repository = ref.read(cartRepositoryProvider);
  return repository.getCart();
});

class CartNotifier extends StateNotifier<AsyncValue<CartModel?>> {
  CartNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchCart();
  }

  final Ref ref;

  Future<void> fetchCart() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(cartRepositoryProvider);
      final cart = await repository.getCart();
      state = AsyncValue.data(cart);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<bool> addToCart(String productId, int quantity) async {
    try {
      final repository = ref.read(cartRepositoryProvider);
      final success = await repository.addToCart(productId, quantity);
      if (success) {
        await fetchCart(); // Refresh cart after adding
      }
      return success;
    } catch (e) {
      return false;
    }
  }
}

final cartNotifierProvider =
    StateNotifierProvider<CartNotifier, AsyncValue<CartModel?>>((ref) {
      return CartNotifier(ref);
    });
