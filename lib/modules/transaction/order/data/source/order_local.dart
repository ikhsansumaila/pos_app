import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:pos_app/core/services/sync/queue/sync_queue_helper.dart';
import 'package:pos_app/core/storage/local_storage_service.dart';
import 'package:pos_app/modules/transaction/order/data/models/order_model.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

class OrderLocalDataSource {
  final Box cacheBox;
  final Box queueBox;

  late final SyncQueueDataHelper<OrderModel> queueHelper;

  OrderLocalDataSource({required this.cacheBox, required this.queueBox}) {
    queueHelper = SyncQueueDataHelper<OrderModel>(
      box: queueBox,
      key: QUEUE_ORDER_KEY,
      fromJson: OrderModel.fromJson,
      toJson: (e) => e.toJson(),
    );
  }

  List<OrderModel> getCachedOrders() {
    final data = cacheBox.get(ORDER_BOX_KEY, defaultValue: []);
    return (data as List).map((e) => OrderModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> update(List<OrderModel> orders) async {
    // add/update/remove cached orders
    await LocalStorageService.updateFromRemote<OrderModel>(box: cacheBox, apiData: orders);
    log("after caching ${orders.length} orders");
  }

  void addToQueue(OrderModel item) {
    queueHelper.addToQueue(item);
  }

  List<OrderModel> getQueuedItems() {
    return queueHelper.getQueuedItems();
  }

  void clearQueue() {
    queueHelper.clearAllQueue();
  }

  Future<void> deleteQueueAt(int index) async {
    queueHelper.deleteQueueAt(index);
  }
}
