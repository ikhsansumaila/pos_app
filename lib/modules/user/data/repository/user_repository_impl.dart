// data/repository/product_repository_impl.dart
import 'dart:developer';

import 'package:pos_app/core/network/connectivity_service.dart';
import 'package:pos_app/modules/user/data/models/user_create_model.dart';
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

      for (final item in local.getQueuedItems()) {
        log("queue item ${item.toJson()}");
      }
    } else {
      // if offline mode, save to local queue
      local.addToQueue(user);
    }
  }

  @override
  Future<bool> processQueue() async {
    // TODO: ADD BULKING POST and call clearAllQueue after ?

    final queue = local.getQueuedItems(); // dari Hive

    while (queue.isNotEmpty) {
      try {
        final item = queue[0]; // send FIFO

        // Re-send pending data
        log('trying to send ${item.toJson()}');
        var response = await remote.postUser(item);

        // Jika berhasil, hapus data dari queue
        if (response.statusCode == 200 || response.statusCode == 201) {
          await local.deleteQueueAt(0); // Hapus data yg sukses
          continue;
        }

        return false;
      } catch (e) {
        // Jika gagal lagi, data tetap ada di queue
        return false;
      }
    }

    return true;
  }
}
