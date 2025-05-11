// data/datasources/product_local_datasource.dart
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:pos_app/core/services/sync/queue/sync_queue_helper.dart';
import 'package:pos_app/core/services/sync/sync_api_service.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

class ProductLocalDataSource {
  final Box cacheBox;
  final Box queueBox;

  late final SyncQueueDataHelper<ProductModel> syncHelper;

  ProductLocalDataSource(this.cacheBox, this.queueBox) {
    syncHelper = SyncQueueDataHelper<ProductModel>(
      box: queueBox,
      key: QUEUE_PRODUCT_KEY,
      fromJson: ProductModel.fromJson,
      toJson: (e) => e.toJson(),
    );
  }

  List<ProductModel> getCachedProducts() {
    log("get products from cache");
    final data = cacheBox.get(PRODUCT_BOX_KEY, defaultValue: []);
    return (data as List).map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> updateCache(List<ProductModel> products) async {
    // add/update/remove cached products
    await SyncHive.updateFromRemote<ProductModel>(boxName: PRODUCT_BOX_KEY, apiData: products);
  }

  void addToQueue(ProductModel item) {
    syncHelper.addToQueue(item);
  }

  List<ProductModel> getQueuedItems() {
    return syncHelper.getQueuedItems();
  }

  void clearQueue() {
    syncHelper.clearAllQueue();
  }

  Future<void> deleteQueueAt(int index) async {
    syncHelper.deleteQueueAt(index);
  }
}
