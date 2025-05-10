import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:pos_app/core/services/sync/queue/sync_queue_helper.dart';
import 'package:pos_app/core/services/sync/sync_api_service.dart';
import 'package:pos_app/modules/transaction/order/data/models/order_model.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

class OrderLocalDataSource {
  final Box box;
  late final SyncQueueDataHelper<Order> syncHelper;

  OrderLocalDataSource(this.box) {
    syncHelper = SyncQueueDataHelper<Order>(
      box: box,
      key: QUEUE_ORDER_KEY,
      fromJson: Order.fromJson,
      toJson: (e) => e.toJson(),
    );
  }

  List<Order> getCachedOrders() {
    final data = box.get(ORDER_BOX_KEY, defaultValue: []);
    return (data as List)
        .map((e) => Order.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> update(List<Order> orders) async {
    // add/update/remove cached orders
    await SyncHive.updateFromRemote<Order>(
      boxName: ORDER_BOX_KEY,
      apiData: orders,
    );
    log("after caching ${orders.length} orders");
  }

  void addToQueue(Order item) {
    syncHelper.addToQueue(item);
  }

  List<Order> getQueuedItems() {
    return syncHelper.getQueuedItems();
  }

  void clearQueue() {
    syncHelper.clearQueue();
  }
}
