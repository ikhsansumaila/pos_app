// data/datasources/product_local_datasource.dart
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:pos_app/core/services/sync/queue/sync_queue_helper.dart';
import 'package:pos_app/core/services/sync/sync_api_service.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

class ProductLocalDataSource {
  final Box box;
  late final SyncQueueDataHelper<Product> syncHelper;

  ProductLocalDataSource(this.box) {
    syncHelper = SyncQueueDataHelper<Product>(
      box: box,
      key: QUEUE_PRODUCT_KEY,
      fromJson: Product.fromJson,
      toJson: (e) => e.toJson(),
    );
  }

  List<Product> getCachedProducts() {
    log("get products from cache");
    final data = box.get(PRODUCT_BOX_KEY, defaultValue: []);
    return (data as List)
        .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> updateCache(List<Product> products) async {
    // add/update/remove cached products
    await SyncHive.updateFromRemote<Product>(
      boxName: PRODUCT_BOX_KEY,
      apiData: products,
    );
  }

  void addToQueue(Product item) {
    syncHelper.addToQueue(item);
  }

  List<Product> getQueuedItems() {
    return syncHelper.getQueuedItems();
  }

  void clearQueue() {
    syncHelper.clearQueue();
  }
}
