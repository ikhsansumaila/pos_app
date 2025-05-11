import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:pos_app/core/services/sync/queue/sync_queue_helper.dart';
import 'package:pos_app/core/services/sync/sync_api_service.dart';
import 'package:pos_app/modules/transaction/main/data/models/transaction_create_model.dart';
import 'package:pos_app/modules/transaction/main/data/models/transaction_model.dart';
import 'package:pos_app/modules/user/data/models/user_create_model.dart';
import 'package:pos_app/modules/user/data/models/user_model.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

class TransactionLocalDataSource {
  final Box cacheBox;
  final Box queueBox;

  late final SyncQueueDataHelper<TransactionCreateModel> syncHelper;

  TransactionLocalDataSource(this.cacheBox, this.queueBox) {
    // this sync only for create user
    syncHelper = SyncQueueDataHelper<TransactionCreateModel>(
      box: queueBox,
      key: QUEUE_TRANSACTION_KEY,
      fromJson: TransactionCreateModel.fromJson,
      toJson: (e) => e.toJson(),
    );
  }

  List<TransactionModel> getCachedTransaction() {
    log("get transactions from cache");
    final data = cacheBox.get(TRANSACTION_BOX_KEY, defaultValue: []);
    return (data as List).map((e) => TransactionModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> updateCache(List<TransactionModel> trx) async {
    // add/update/remove cached
    await SyncHive.updateFromRemote<TransactionModel>(boxName: TRANSACTION_BOX_KEY, apiData: trx);
  }

  void addToQueue(TransactionCreateModel item) {
    syncHelper.addToQueue(item);
  }

  List<TransactionCreateModel> getQueuedItems() {
    return syncHelper.getQueuedItems();
  }

  void clearQueue() {
    syncHelper.clearAllQueue();
  }

  Future<void> deleteQueueAt(int index) async {
    syncHelper.deleteQueueAt(index);
  }
}
