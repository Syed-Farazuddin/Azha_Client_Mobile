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
    // Parse the first image URL from the product's images array
    String imageUrl = '';
    final product = json['productId'];
    if (product != null &&
        product['images'] != null &&
        product['images'] is List) {
      for (var img in product['images']) {
        if (img is Map && img['imageUrl'] != null) {
          imageUrl = img['imageUrl'].toString();
          break;
        } else if (img is String) {
          imageUrl = img;
          break;
        }
      }
    }

    return CartItemModel(
      productId:
          product?['id']?.toString() ?? product?['_id']?.toString() ?? '',
      title: product?['title'] ?? json['title'] ?? '',
      image: imageUrl,
      price: (product?['price'] ?? json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }
}

class CartModel {
  final String id;
  final List<CartItemModel> items;

  CartModel({required this.id, required this.items});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    var itemsList = json['products'] as List? ?? json['items'] as List? ?? [];
    return CartModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      items: itemsList.map((e) => CartItemModel.fromJson(e)).toList(),
    );
  }
}
