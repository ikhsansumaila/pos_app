// domain/repository/product_repository.dart

import 'package:pos_app/modules/transaction/order/data/models/order_model.dart';

abstract class OrderRepository {
  // Future<void> initLocalDataSource();
  Future<List<OrderModel>> getOrders();
  Future<void> postOrder(OrderModel product);
  Future<bool> processQueue(); // use in background sync process
}
