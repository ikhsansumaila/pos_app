// data/datasources/product_remote_datasource.dart
import 'dart:developer';

import 'package:pos_app/core/network/dio_client.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';

class ProductRemoteDataSource {
  final DioClient dio;
  ProductRemoteDataSource(this.dio);

  Future<List<Product>> fetchProducts() async {
    final response = await dio.get('/api/produk?store_id=1');
    log('response.data ${response.data}');
    return (response.data as List).map((e) {
      Map<String, dynamic> map = e;
      log("map $map");
      return Product.fromJson(map);
    }).toList();
  }

  Future<void> postProduct(Product product) async {
    await dio.post('/products', data: product.toJson());
  }
}
