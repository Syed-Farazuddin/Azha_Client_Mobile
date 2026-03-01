import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/network/urls.dart';
import 'package:mobile/features/orders/data/models/order_model.dart';
import 'package:mobile/features/orders/domain/repositories/order_repository.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final apiClient = ref.read(apiClientServiceProvider);
  return OrderRepositoryImpl(apiClient: apiClient);
});

class OrderRepositoryImpl implements OrderRepository {
  final ApiClientService apiClient;

  OrderRepositoryImpl({required this.apiClient});

  @override
  Future<OrderModel?> confirmOrder({
    required String productId,
    required double price,
    required Map<String, dynamic> deliveryAddress,
    required int quantity,
    required String paymentMethod,
    required String paymentId,
    required String mobile,
  }) async {
    try {
      final response = await apiClient.post(
        NetworkUrls.confirmOrder(productId),
        body: {
          'price': price,
          'deliveryAddress': deliveryAddress,
          'quantity': quantity,
          'paymentMethod': paymentMethod,
          'paymentId': paymentId,
          'mobile': mobile,
        },
      );
      if (response['success'] == true && response['order'] != null) {
        return OrderModel.fromJson(response['order']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<OrderModel?> getOrderDetails(String orderId) async {
    try {
      final response = await apiClient.get(
        NetworkUrls.getOrderDetails(orderId),
      );
      if (response['success'] == true && response['order'] != null) {
        return OrderModel.fromJson(response['order']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
