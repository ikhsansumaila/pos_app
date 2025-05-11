import 'package:pos_app/modules/product/data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getProducts();
  Future<void> postProduct(ProductModel product);
  Future<bool> processQueue(); // use in background sync process
}
