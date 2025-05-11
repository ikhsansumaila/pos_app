import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pos_app/core/services/sync/queue/sync_queue_helper.dart';
import 'package:pos_app/core/services/sync/sync_api_service.dart';
import 'package:pos_app/modules/transaction/main/data/models/transaction_create_model.dart';
import 'package:pos_app/modules/transaction/main/data/models/transaction_model.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

class TransactionLocalDataSource extends GetxController {
  final Box cacheBox;
  final Box queueBox;

  late final SyncQueueDataHelper<TransactionCreateModel> queueHelper;

  TransactionLocalDataSource(this.cacheBox, this.queueBox) {
    // this sync only for create transactions
    queueHelper = SyncQueueDataHelper<TransactionCreateModel>(
      box: queueBox,
      key: QUEUE_TRANSACTION_KEY,
      fromJson: TransactionCreateModel.fromJson,
      toJson: (e) => e.toJson(),
    );
  }

  List<TransactionModel> getCachedTransaction() {
    log("get transactions from cache");
    final data = cacheBox.get(TRANSACTION_BOX_KEY, defaultValue: []);
    return (data as List)
        .map((e) => TransactionModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> updateCache(List<TransactionModel> trx) async {
    // add/update/remove cached
    await SyncHive.updateFromRemote<TransactionModel>(
      boxName: TRANSACTION_BOX_KEY,
      apiData: trx,
    );
  }

  void addToQueue(TransactionCreateModel item) {
    queueHelper.addToQueue(item);
  }

  List<TransactionCreateModel> getQueuedItems() {
    return queueHelper.getQueuedItems();
  }

  void clearQueue() {
    queueHelper.clearAllQueue();
  }

  Future<void> deleteQueueAt(int index) async {
    queueHelper.deleteQueueAt(index);
  }
}
