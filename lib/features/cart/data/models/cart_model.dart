class CartItemModel {
  final String productId;
  final String title;
  final String image;
  final double price;
  final int quantity;

  CartItemModel({
    required this.productId,
    required this.title,
    required this.image,
    required this.price,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId']?['_id'] ?? '',
      title: json['productId']?['title'] ?? '',
      image:
          (json['productId']?['images'] != null &&
              json['productId']['images'].isNotEmpty)
          ? json['productId']['images'][0]
          : '',
      price: (json['productId']?['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }
}

class CartModel {
  final String id;
  final List<CartItemModel> items;

  CartModel({required this.id, required this.items});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    var itemsList = json['products'] as List? ?? [];
    return CartModel(
      id: json['_id'] ?? '',
      items: itemsList.map((e) => CartItemModel.fromJson(e)).toList(),
    );
  }
}
