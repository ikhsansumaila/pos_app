// domain/repository/product_repository.dart
import 'package:pos_app/data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<void> postProduct(Product product);
  Future<bool> processQueue();
}
