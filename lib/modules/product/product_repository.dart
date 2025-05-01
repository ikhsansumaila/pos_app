import 'dart:developer';

import 'package:pos_app/modules/product/product_models.dart';
import 'package:pos_app/utils/api/base.dart';
import 'package:pos_app/utils/api/response.dart';

class ProductRepository extends BaseRepository {
  Future<ApiResponse<List<Product>>> getAllProducts() {
    return safeRequest<List<Product>>(
      () => dio.get('https://dummyjson.com/products'),
      (data) {
        // log("data: $data");
        log("data: $data");
        log("runtimeType: ${(data['products'] as List).runtimeType}");
        // var mydata = data['data']['products'] as List;
        // log("mydata: ${mydata.runtimeType}");

        return (data['products'] as List).map((e) {
          log("map data: $e");
          log("map data runtimeType: ${e.runtimeType}");
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
