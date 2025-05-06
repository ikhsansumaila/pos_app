// data/repository/product_repository_impl.dart
import 'package:pos_app/core/network/connectivity_service.dart';
import 'package:pos_app/data/models/order_model.dart';
import 'package:pos_app/data/repository/order/order_repository.dart';
import 'package:pos_app/data/repository/order/source/order_local.dart';
import 'package:pos_app/data/repository/order/source/order_remote.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remote;
  final OrderLocalDataSource local;
  final ConnectivityService connectivity;

  OrderRepositoryImpl(this.remote, this.local, this.connectivity);

  @override
  Future<List<Order>> getOrders() async {
    if (await connectivity.isConnected()) {
      final orders = await remote.fetchOrders();
      local.cacheOrders(orders);
      return orders;
    } else {
      return local.getCachedOrders();
    }
  }

  @override
  Future<void> postOrder(Order order) async {
    if (await connectivity.isConnected()) {
      await remote.postOrder(order);
      await processQueue(); // send pending posts
    } else {
      local.queueOrderPost(order); // simpan queue lokal
    }
  }

  @override
  Future<bool> processQueue() async {
    try {
      final queue = local.getQueuedPosts(); // dari Hive
      for (final item in queue) {
        await remote.postOrder(item);
      }
      local.clearQueue();
      return true;
    } catch (_) {
      return false;
    }
  }
}
