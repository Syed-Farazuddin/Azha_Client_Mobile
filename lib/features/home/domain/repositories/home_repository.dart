import 'package:mobile/features/home/data/models/category_model.dart';
import 'package:mobile/features/home/data/models/product_model.dart';

abstract class HomeRepository {
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getProducts();
  Future<List<ProductModel>> getSuggestedProducts();
  Future<List<ProductModel>> getMostRatedProducts();
}
