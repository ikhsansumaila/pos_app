// data/datasources/product_remote_datasource.dart
import 'dart:convert';
import 'dart:developer';

import 'package:pos_app/core/network/dio_client.dart';
import 'package:pos_app/core/network/response.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/utils/constants/rest.dart';

class ProductRemoteDataSource {
  final DioClient dio;
  ProductRemoteDataSource({required this.dio});

  Future<List<ProductModel>> fetchProducts() async {
    final response = await dio.get('$PRODUCT_API_URL?store_id=1');
    if (response.isSuccess) {
      return (response.data as List).map((e) {
        Map<String, dynamic> map = e;
        log("map $map");
        return ProductModel.fromJson(map);
      }).toList();
    }

    return [];

    // log('response.data ${response.data}');
    // return (response.data as List).map((e) {
    //   Map<String, dynamic> map = e;
    //   log("map $map");
    //   return ProductModel.fromJson(map);
    // }).toList();
  }

  Future<ApiResponse> postProduct(ProductModel product) async {
    return await dio.post(PRODUCT_API_URL, data: product.toJson());
  }

  //TODO: USE IT OR NOT?
  Future<void> postBulkProduct(List<ProductModel> products) async {
    final data = jsonEncode(products.map((u) => u.toJson()).toList());
    await dio.post(PRODUCT_API_URL, data: data);
  }
}
