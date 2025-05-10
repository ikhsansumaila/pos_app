// data/datasources/product_local_datasource.dart
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:pos_app/core/services/sync/queue/sync_queue_helper.dart';
import 'package:pos_app/core/services/sync/sync_api_service.dart';
import 'package:pos_app/modules/user/data/models/user_model.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

class UserLocalDataSource {
  final Box box;
  late final SyncQueueDataHelper<User> syncHelper;

  UserLocalDataSource(this.box) {
    syncHelper = SyncQueueDataHelper<User>(
      box: box,
      key: QUEUE_USER_KEY,
      fromJson: User.fromJson,
      toJson: (e) => e.toJson(),
    );
  }

  List<User> getCachedUsers() {
    log("get products from cache");
    final data = box.get(USER_BOX_KEY, defaultValue: []);
    return (data as List)
        .map((e) => User.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> updateCache(List<User> users) async {
    // add/update/remove cached
    await SyncHive.updateFromRemote<User>(
      boxName: USER_BOX_KEY,
      apiData: users,
    );
  }

  void addToQueue(User item) {
    syncHelper.addToQueue(item);
  }

  List<User> getQueuedItems() {
    return syncHelper.getQueuedItems();
  }

  void clearQueue() {
    syncHelper.clearQueue();
  }
}
