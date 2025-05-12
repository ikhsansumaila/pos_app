import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:pos_app/core/services/sync/queue/sync_queue_helper.dart';
import 'package:pos_app/core/storage/local_storage_service.dart';
import 'package:pos_app/modules/user/data/models/user_create_model.dart';
import 'package:pos_app/modules/user/data/models/user_model.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

class UserLocalDataSource {
  final Box cacheBox;
  final Box queueBox;

  late final SyncQueueDataHelper<UserCreateModel> queueHelper;

  UserLocalDataSource({required this.cacheBox, required this.queueBox}) {
    // this sync only for create user
    queueHelper = SyncQueueDataHelper<UserCreateModel>(
      box: queueBox,
      key: QUEUE_USER_KEY,
      fromJson: UserCreateModel.fromJson,
      toJson: (e) => e.toJson(),
    );
  }

  List<UserModel> getCachedUsers() {
    log("get products from cache");
    final data = cacheBox.get(USER_BOX_KEY, defaultValue: []);
    return (data as List)
        .map((e) => UserModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> updateCache(List<UserModel> users) async {
    // add/update/remove cached
    await LocalStorageService.updateFromRemote<UserModel>(
      boxName: USER_BOX_KEY,
      apiData: users,
    );
  }

  void addToQueue(UserCreateModel item) {
    queueHelper.addToQueue(item);
  }

  List<UserCreateModel> getQueuedItems() {
    return queueHelper.getQueuedItems();
  }

  void clearQueue() {
    queueHelper.clearAllQueue();
  }

  Future<void> deleteQueueAt(int index) async {
    queueHelper.deleteQueueAt(index);
  }
}
