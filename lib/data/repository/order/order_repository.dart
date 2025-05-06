// domain/repository/product_repository.dart

import 'package:pos_app/data/models/order_model.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders();
  Future<void> postOrder(Order product);
  Future<bool> processQueue();
}
