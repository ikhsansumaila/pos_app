import 'package:pos_app/modules/product/model/product_model.dart';
import 'package:pos_app/utils/api/base.dart';
import 'package:pos_app/utils/api/response.dart';

class ProductRepository extends BaseRepository {
  Future<ApiResponse<List<Product>>> getAllProducts() {
    return safeRequest<List<Product>>(
      () => dio.get('https://dummyjson.com/products'),
      (data) {
        // log("data request $data");
        return (data['products'] as List).map((e) {
          Map<String, dynamic> map = e;
          return Product.fromJson(map);
        }).toList();
      },
    );
  }

  Future<ApiResponse<Product>> getProductById(int id) {
    return safeRequest<Product>(
      () => dio.get('https://dummyjson.com/products/$id'),
      (data) => Product.fromJson(data),
    );
  }
}
