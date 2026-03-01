import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/orders/data/models/order_model.dart';
import 'package:mobile/features/orders/data/repositories/order_repository_impl.dart';

class OrderNotifier extends StateNotifier<AsyncValue<OrderModel?>> {
  OrderNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<OrderModel?> confirmOrder({
    required String productId,
    required double price,
    required Map<String, dynamic> deliveryAddress,
    required int quantity,
    required String paymentMethod,
    required String paymentId,
    required String mobile,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(orderRepositoryProvider);
      final order = await repository.confirmOrder(
        productId: productId,
        price: price,
        deliveryAddress: deliveryAddress,
        quantity: quantity,
        paymentMethod: paymentMethod,
        paymentId: paymentId,
        mobile: mobile,
      );
      state = AsyncValue.data(order);
      return order;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }
}

final orderNotifierProvider =
    StateNotifierProvider<OrderNotifier, AsyncValue<OrderModel?>>((ref) {
      return OrderNotifier(ref);
    });

final orderDetailsProvider = FutureProvider.family<OrderModel?, String>((
  ref,
  id,
) async {
  final repository = ref.read(orderRepositoryProvider);
  return repository.getOrderDetails(id);
});
