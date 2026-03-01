class ProductModel {
  final String id;
  final String title;
  final double price;
  final double? originalPrice;
  final String? image;
  final List<String> images;
  final double? rating;
  final int? numReviews;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    this.originalPrice,
    this.image,
    this.images = const [],
    this.rating,
    this.numReviews,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      image:
          json['image'] ??
          (json['images'] != null && json['images'].isNotEmpty
              ? json['images'][0]
              : null),
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      rating: json['rating'] != null ? (json['rating']).toDouble() : null,
      numReviews: json['numReviews'],
    );
  }
}
