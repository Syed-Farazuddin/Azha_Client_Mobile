class ProductModel {
  final String id;
  final String title;
  final String? description;
  final String? bio;
  final double price;
  final double? originalPrice;
  final double? discount;
  final String? image;
  final List<String> images;
  final double? rating;
  final int? numReviews;
  final String? categoryName;
  final String? reviewTitle;
  final String? reviewDescription;
  final double? reviewRating;

  ProductModel({
    required this.id,
    required this.title,
    this.description,
    this.bio,
    required this.price,
    this.originalPrice,
    this.discount,
    this.image,
    this.images = const [],
    this.rating,
    this.numReviews,
    this.categoryName,
    this.reviewTitle,
    this.reviewDescription,
    this.reviewRating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Parse images — API returns List<{imageUrl, ...}> objects
    List<String> parsedImages = [];
    if (json['images'] != null && json['images'] is List) {
      for (var img in json['images']) {
        if (img is Map && img['imageUrl'] != null) {
          parsedImages.add(img['imageUrl'].toString());
        } else if (img is String) {
          parsedImages.add(img);
        }
      }
    }

    // Calculate original price from price + discount
    final double currentPrice = (json['price'] ?? 0).toDouble();
    final double? discountVal = json['discount'] != null
        ? (json['discount']).toDouble()
        : null;
    final double? original = discountVal != null
        ? currentPrice + discountVal
        : null;

    // Parse review
    String? reviewTitle;
    String? reviewDescription;
    double? reviewRating;
    if (json['review'] != null && json['review'] is Map) {
      reviewTitle = json['review']['title'];
      reviewDescription = json['review']['description'];
      reviewRating = json['review']['rating'] != null
          ? (json['review']['rating']).toDouble()
          : null;
    }

    return ProductModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      bio: json['bio'],
      price: currentPrice,
      discount: discountVal,
      originalPrice: original ?? json['originalPrice']?.toDouble(),
      image: parsedImages.isNotEmpty ? parsedImages.first : json['image'],
      images: parsedImages,
      rating:
          reviewRating ??
          (json['rating'] != null ? (json['rating']).toDouble() : null),
      numReviews: json['numReviews'],
      categoryName: json['category'] != null && json['category'] is Map
          ? json['category']['name']
          : null,
      reviewTitle: reviewTitle,
      reviewDescription: reviewDescription,
      reviewRating: reviewRating,
    );
  }
}
