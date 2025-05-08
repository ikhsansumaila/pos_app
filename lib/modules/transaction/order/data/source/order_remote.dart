// data/datasources/product_remote_datasource.dart
import 'package:pos_app/core/network/dio_client.dart';
import 'package:pos_app/modules/transaction/order/data/models/order_model.dart';

class OrderRemoteDataSource {
  final DioClient dio;
  OrderRemoteDataSource(this.dio);

  Future<List<Order>> fetchOrders() async {
    final response = await dio.get('/orders');
    return (response.data as List).map((e) => Order.fromJson(e)).toList();
  }

  Future<void> postOrder(Order order) async {
    await dio.post('/orders', data: order.toJson());
  }
}
