// import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:pos_app/core/network/connectivity_service.dart';
import 'package:pos_app/modules/common/widgets/app_dialog.dart';
import 'package:pos_app/modules/user/data/models/user_model.dart';
import 'package:pos_app/modules/user/data/models/user_role_model.dart';
import 'package:pos_app/modules/user/data/repository/user_repository.dart';
import 'package:pos_app/modules/user/data/source/user_local.dart';
import 'package:pos_app/modules/user/data/source/user_remote.dart';
import 'package:pos_app/utils/cache_helper.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;
  final UserLocalDataSource local;
  final ConnectivityService connectivity;

  UserRepositoryImpl({required this.remote, required this.local, required this.connectivity});

  @override
  Future<List<UserModel>> getUsers() async {
    final isOnline = await connectivity.isConnected();

    if (!isOnline) {
      return local.getCachedUsers();
    }

    try {
      final users = await remote.fetchUsers();
      log('users fetched: ${users.length}');
      final newUser = [users[0], users[1]];
      await local.updateCache(newUser);

      return newUser;
    } catch (e, stackTrace) {
      log("Error fetching users: $e", stackTrace: stackTrace);
      await AppDialog.show('Terjadi kesalahan', content: 'Error: $e');
      return local.getCachedUsers();
    }
  }

  @override
  Future<void> postUser(UserModel user) async {
    log("user.toJsonCreate() : ${user.toJsonCreate()}");
    if (await connectivity.isConnected()) {
      var response = await remote.postUser(user.toJsonCreate());
      if (response.statusCode != 200 && response.statusCode != 201) {
        await AppDialog.show('Terjadi kesalahan', content: 'Error: ${response.data}');
        return;
      }

      await AppDialog.showCreateSuccess();
      Get.back();

      return;
    }

    await AppDialog.showErrorOffline();
    return;

    // =================================== DELETED SOON =========================================
    // // for send to remote/queue
    // UserCreateModel userCreate = UserCreateModel.fromJson(userFormData.toJson());

    // // for updating local cache
    // UserModel userCache = UserModel.setByFormData(userFormData);

    // if (await connectivity.isConnected()) {
    //   var response = await remote.postUser(userCreate);

    //   // if failed, save to local queue
    //   if (response.statusCode != 200 && response.statusCode != 201) {
    //     local.addToQueue(userCreate); // simpan queue lokal
    //     await local.addToCache(userCache);
    //   }
    // } else {
    //   // if offline mode, save to local queue
    //   local.addToQueue(userCreate);
    //   await local.addToCache(userCache);
    // }
  }

  @override
  Future<List<UserRoleModel>> getRoles() async {
    final isOnline = await connectivity.isConnected();

    if (!isOnline) {
      return local.getCachedUserRoles();
    }

    try {
      final roles = await remote.fetchUserRoles();
      await local.updateUserRolesCache(roles);
      return roles;
    } catch (e, stackTrace) {
      log("Error fetching user roles: $e", stackTrace: stackTrace);
      return local.getCachedUserRoles();
    }
  }

  @override
  int generateNextCacheId() {
    return CacheHelper.generateNextCacheId(local.userCacheBox);
  }
}
