import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:pos_app/core/storage/local_storage_service.dart';
import 'package:pos_app/modules/store/data/models/store_model.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

class StoreLocalDataSource {
  final Box cacheBox;

  // late final SyncQueueDataHelper<UserCreateModel> queueHelper;

  StoreLocalDataSource({required this.cacheBox}) {
    // this sync only for create user
    // queueHelper = SyncQueueDataHelper<UserCreateModel>(
    //   box: queueBox,
    //   key: QUEUE_USER_KEY,
    //   fromJson: UserCreateModel.fromJson,
    //   toJson: (e) => e.toJson(),
    // );
  }

  List<StoreModel> getCachedStores() {
    log("get stores from cache");
    final data = cacheBox.get(STORE_BOX_KEY, defaultValue: []);
    return (data as List).map((e) => StoreModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> updateStoreCache(List<StoreModel> stores) async {
    // add/update/remove cached
    await LocalStorageService.updateFromRemote<StoreModel>(box: cacheBox, apiData: stores);
  }

  // void addToQueue(UserCreateModel item) {
  //   queueHelper.addToQueue(item);
  // }

  // List<UserCreateModel> getQueuedItems() {
  //   return queueHelper.getQueuedItems();
  // }

  // void clearQueue() {
  //   queueHelper.clearAllQueue();
  // }

  // Future<void> deleteQueueAt(int index) async {
  //   queueHelper.deleteQueueAt(index);
  // }
}
