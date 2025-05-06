// data/datasources/product_remote_datasource.dart
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_app/data/models/product_model.dart';
import 'package:pos_app/utils/api/base.dart';

class ProductRemoteDataSource extends BaseRepository {
  final Dio dio;
  ProductRemoteDataSource(this.dio);

  Future<List<Product>> fetchProducts() async {
    final response = await dio.get('/api/produk?store=1');
    return (response.data as List).map((e) {
      Map<String, dynamic> map = e;
      log("map $map");
      var product = Product.fromJson(map);
      log("product.idBrg ${product.idBrg} ${product.idBrg.runtimeType}");
      log(
        "product.hargaBeli ${product.hargaBeli} ${product.hargaBeli.runtimeType}",
      );
      return Product.fromJson(map);
    }).toList();
  }

  Future<void> postProduct(Product product) async {
    await dio.post('/products', data: product.toJson());
  }

  // Future<ApiResponse<List<Product>>> getAllProducts() {
  //   return safeRequest<
  //     List<Product>
  //   >(() => dio.get('https://esiportal.com/api/produk?store=1'), (data) {
  //     return (data as List).map((e) {
  //       Map<String, dynamic> map = e;
  //       log("map $map");
  //       var product = Product.fromJson(map);
  //       log("product.idBrg ${product.idBrg} ${product.idBrg.runtimeType}");
  //       log(
  //         "product.hargaBeli ${product.hargaBeli} ${product.hargaBeli.runtimeType}",
  //       );
  //       return Product.fromJson(map);
  //     }).toList();
  //   });
  // }
}
