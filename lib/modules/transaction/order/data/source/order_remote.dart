// data/datasources/product_remote_datasource.dart
import 'package:pos_app/core/network/dio_client.dart';
import 'package:pos_app/core/network/response.dart';
import 'package:pos_app/modules/transaction/order/data/models/order_model.dart';
import 'package:pos_app/utils/constants/constant.dart';

class OrderRemoteDataSource {
  final DioClient dio;
  OrderRemoteDataSource(this.dio);

  Future<List<OrderModel>> fetchOrders() async {
    final response = await dio.get(ORDER_API_URL);
    if (response.isSuccess) {
      return (response.data as List)
          .map((e) => OrderModel.fromJson(e))
          .toList();
    }

    return [];
  }

  Future<ApiResponse> postOrder(OrderModel order) async {
    return await dio.post(ORDER_API_URL, data: order.toJson());
  }
}
