import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:pos_app/core/services/sync/sync_api_service.dart';
import 'package:pos_app/modules/transaction/order/data/models/order_model.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

class OrderLocalDataSource {
  final Box box;
  OrderLocalDataSource(this.box);

  List<Order> getCachedOrders() {
    final data = box.get(ORDER_BOX_KEY, defaultValue: []);
    return (data as List)
        .map((e) => Order.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // void cacheOrders(List<Order> orders) {
  //   box.put(ORDER_BOX_KEY, orders.map((e) => e.toJson()).toList());
  // }

  Future<void> update(List<Order> orders) async {
    // add/update/remove cached orders
    await SyncHive.updateFromRemote<Order>(
      boxName: ORDER_BOX_KEY,
      apiData: orders,
    );
    log("after caching ${orders.length} orders");
  }

  void queueOrderPost(Order orders) {
    final queue = box.get(POST_QUEUE_KEY, defaultValue: []);
    queue.add(orders.toJson());
    box.put(POST_QUEUE_KEY, queue);
  }

  List<Order> getQueuedPosts() {
    final data = box.get(POST_QUEUE_KEY, defaultValue: []);
    return (data as List)
        .map((e) => Order.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  void clearQueue() {
    box.put(POST_QUEUE_KEY, []);
  }
}
