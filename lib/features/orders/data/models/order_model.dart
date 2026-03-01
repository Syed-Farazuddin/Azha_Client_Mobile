class OrderModel {
  final String id;
  final String userId;
  final double totalPrice;
  final String? trackingId;

  OrderModel({
    required this.id,
    required this.userId,
    required this.totalPrice,
    this.trackingId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      trackingId: json['trackingId'],
    );
  }
}
