import 'package:hive/hive.dart';
import 'package:pos_app/core/storage/local_storage_service.dart';
import 'package:pos_app/modules/user/data/models/user_model.dart';
import 'package:pos_app/modules/user/data/models/user_role_model.dart';

class UserLocalDataSource {
  final Box userCacheBox;
  final Box roleCacheBox;
  // final Box queueBox;

  // late final SyncQueueDataHelper<UserCreateModel> queueHelper;

  UserLocalDataSource({
    required this.userCacheBox,
    required this.roleCacheBox,
    // required this.queueBox,
  }) {
    // this sync only for create user
    // queueHelper = SyncQueueDataHelper<UserCreateModel>(
    //   box: queueBox,
    //   key: QUEUE_USER_KEY,
    //   fromJson: UserCreateModel.fromJson,
    //   toJson: (e) => e.toJson(),
    // );
  }

  List<UserModel> getCachedUsers() {
    return userCacheBox.values.map((element) => element as UserModel).toList();
  }

  List<UserRoleModel> getCachedUserRoles() {
    return roleCacheBox.values.map((element) => element as UserRoleModel).toList();
  }

  Future<LocalStorageUpdateResult> updateCache(List<UserModel> users) async {
    // add/update/remove cached
    return await LocalStorageService.updateFromRemote<UserModel>(box: userCacheBox, apiData: users);
  }

  Future<void> updateUserRolesCache(List<UserRoleModel> roles) async {
    // add/update/remove cached
    await LocalStorageService.updateFromRemote<UserRoleModel>(box: roleCacheBox, apiData: roles);
  }

  Future<void> addUserToCache(UserModel user) async {
    await userCacheBox.add(user);
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
