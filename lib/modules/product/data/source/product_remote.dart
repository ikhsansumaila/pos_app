// data/datasources/product_remote_datasource.dart
import 'package:pos_app/core/network/dio_client.dart';
import 'package:pos_app/core/network/response.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/utils/constants/rest.dart';

class ProductRemoteDataSource {
  final DioClient dio;
  ProductRemoteDataSource({required this.dio});

  Future<List<ProductModel>> fetchProducts(int storeId) async {
    final response = await dio.get('$PRODUCT_API_URL?store_id=$storeId');
    if (response.isSuccess) {
      return (response.data as List).map((e) {
        Map<String, dynamic> map = e;
        // log("map $map");
        return ProductModel.fromJson(map);
      }).toList();
    }

    return [];
  }

  Future<ApiResponse> postProduct(Map<String, dynamic> data) async {
    return await dio.post(PRODUCT_API_URL, data: data);
  }
}
