import 'package:hive/hive.dart';
import 'package:pos_app/core/services/sync/queue/sync_queue_helper.dart';
import 'package:pos_app/core/storage/local_storage_service.dart';
import 'package:pos_app/modules/user/data/models/user_create_model.dart';
import 'package:pos_app/modules/user/data/models/user_model.dart';
import 'package:pos_app/modules/user/data/models/user_role_model.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

class UserLocalDataSource {
  final Box userCacheBox;
  final Box userRoleCacheBox;
  final Box queueBox;

  late final SyncQueueDataHelper<UserCreateModel> queueHelper;

  UserLocalDataSource({
    required this.userCacheBox,
    required this.userRoleCacheBox,
    required this.queueBox,
  }) {
    // this sync only for create user
    queueHelper = SyncQueueDataHelper<UserCreateModel>(
      box: queueBox,
      key: QUEUE_USER_KEY,
      fromJson: UserCreateModel.fromJson,
      toJson: (e) => e.toJson(),
    );
  }

  List<UserModel> getCachedUsers() {
    return userCacheBox.values.map((element) => element as UserModel).toList();
  }

  List<UserRoleModel> getCachedUserRoles() {
    return userRoleCacheBox.values.map((element) => element as UserRoleModel).toList();
  }

  Future<void> updateCache(List<UserModel> users) async {
    // add/update/remove cached
    await LocalStorageService.updateFromRemote<UserModel>(box: userCacheBox, apiData: users);
  }

  Future<void> updateUserRolesCache(List<UserRoleModel> roles) async {
    // add/update/remove cached
    await LocalStorageService.updateFromRemote<UserRoleModel>(
      box: userRoleCacheBox,
      apiData: roles,
    );
  }

  Future<void> addToCache(UserCreateModel userCreate) async {
    await userCacheBox.add(
      UserModel(
        id: userCreate.cacheId,
        cacheId: userCreate.cacheId,
        storeId: userCreate.storeId,
        storeName: "",
        nama: userCreate.nama,
        email: userCreate.email,
        roleId: userCreate.roleId,
        role: "",
        status: userCreate.status,
        createdAt: DateTime.now().toIso8601String(),
      ),
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
