// data/repository/product_repository_impl.dart
import 'dart:developer';

import 'package:pos_app/core/network/connectivity_service.dart';
import 'package:pos_app/modules/user/data/models/user_create_model.dart';
import 'package:pos_app/modules/user/data/models/user_model.dart';
import 'package:pos_app/modules/user/data/models/user_role_model.dart';
import 'package:pos_app/modules/user/data/repository/user_repository.dart';
import 'package:pos_app/modules/user/data/source/user_local.dart';
import 'package:pos_app/modules/user/data/source/user_remote.dart';

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
      await local.updateCache(users);
      return users;
    } catch (e, stackTrace) {
      log("Error fetching users: $e", stackTrace: stackTrace);
      return local.getCachedUsers();
    }
  }

  @override
  Future<void> postUser(UserCreateModel user) async {
    if (await connectivity.isConnected()) {
      var response = await remote.postUser(user);

      // if failed, save to local queue
      if (response.statusCode != 200 && response.statusCode != 201) {
        local.addToQueue(user); // simpan queue lokal
      }
    } else {
      // if offline mode, save to local queue
      local.addToQueue(user);
    }
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
}
