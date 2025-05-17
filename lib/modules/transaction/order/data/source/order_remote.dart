// data/datasources/product_remote_datasource.dart
import 'package:pos_app/core/network/dio_client.dart';
import 'package:pos_app/core/network/response.dart';
import 'package:pos_app/modules/transaction/order/data/models/order_model.dart';
import 'package:pos_app/utils/constants/rest.dart';

class OrderRemoteDataSource {
  final DioClient dio;
  OrderRemoteDataSource({required this.dio});

  Future<List<OrderModel>> fetchOrders() async {
    final response = await dio.request(path: ORDER_API_URL, method: AppHttpMethod.get);
    if (response.isSuccess) {
      return (response.data as List).map((e) => OrderModel.fromJson(e)).toList();
    }

    return [];
  }

  Future<ApiResponse> postOrder(Map<String, dynamic> data) async {
    return await dio.request(path: ORDER_API_URL, method: AppHttpMethod.post, data: data);
  }
}
