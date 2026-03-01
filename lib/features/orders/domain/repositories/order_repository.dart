import 'package:mobile/features/orders/data/models/order_model.dart';

abstract class OrderRepository {
  Future<OrderModel?> confirmOrder({
    required String productId,
    required double price,
    required Map<String, dynamic> deliveryAddress,
    required int quantity,
    required String paymentMethod,
    required String paymentId,
    required String mobile,
  });

  Future<OrderModel?> getOrderDetails(String orderId);
}
