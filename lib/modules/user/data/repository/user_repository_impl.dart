// data/repository/product_repository_impl.dart
import 'dart:developer';

import 'package:pos_app/core/network/connectivity_service.dart';
import 'package:pos_app/modules/user/data/models/user_model.dart';
import 'package:pos_app/modules/user/data/repository/user_repository.dart';
import 'package:pos_app/modules/user/data/source/user_local.dart';
import 'package:pos_app/modules/user/data/source/user_remote.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;
  final UserLocalDataSource local;
  final ConnectivityService connectivity;

  UserRepositoryImpl(this.remote, this.local, this.connectivity);

  @override
  Future<List<User>> getUsers() async {
    if (await connectivity.isConnected()) {
      log("Internet is on");
      try {
        final users = await remote.fetchUsers();
        await local.updateCache(users);
        return users;
      } catch (e) {
        log("Error fetching users: $e");
        return local.getCachedUsers();
      }
    } else {
      log("Internet is off");
      return local.getCachedUsers();
    }
  }

  @override
  Future<void> postUser(User user) async {
    if (await connectivity.isConnected()) {
      await remote.postUser(user);
      await processQueue(); // send pending posts
    } else {
      local.addToQueue(user); // simpan queue lokal
    }
  }

  @override
  Future<bool> processQueue() async {
    try {
      final queue = local.getQueuedItems(); // dari Hive
      for (final item in queue) {
        await remote.postUser(item);
      }
      local.clearQueue();
      return true;
    } catch (_) {
      return false;
    }
  }
}
