import 'package:pos_app/modules/product/data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getProducts(int storeId);
  Future<String?> postProduct(ProductModel product);
}
