import 'package:mobile/features/home/data/models/product_model.dart';

abstract class ProductRepository {
  Future<ProductModel?> getProductById(String id);
  Future<List<ProductModel>> searchProducts(String query);
  Future<bool> addReview(
    String productId,
    String title,
    String description,
    double rating,
  );
}
