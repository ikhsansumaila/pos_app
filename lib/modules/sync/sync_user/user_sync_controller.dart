import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:pos_app/core/network/connectivity_service.dart';
import 'package:pos_app/modules/common/widgets/app_dialog.dart';
import 'package:pos_app/modules/sync/service/local_storage_service.dart';
import 'package:pos_app/modules/sync/sync_log/sync_log_model.dart';
import 'package:pos_app/modules/sync/sync_log/sync_log_service.dart';
import 'package:pos_app/modules/user/data/models/user_model.dart';
import 'package:pos_app/modules/user/data/source/user_local.dart';
import 'package:pos_app/modules/user/data/source/user_remote.dart';

class UserSyncController extends GetxController {
  final UserLocalDataSource local;
  final UserRemoteDataSource remote;
  final SyncLogService logService;
  final ConnectivityService connectivity;

  UserSyncController({
    required this.local,
    required this.remote,
    required this.logService,
    required this.connectivity,
  });

  RxList<UserModel> users = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    users.value = local.getCachedUsers();
  }

  List<UserModel> getUsers() {
    users.value = local.getCachedUsers();
    return users.toList();
  }

  Future<void> startSync() async {
    final isOnline = await connectivity.isConnected();

    if (!isOnline) {
      await AppDialog.showErrorOffline();
      return;
    }

    try {
      final remoteData = await remote.fetchUsers();
      log("users fetched: ${remoteData.length}");
      LocalStorageUpdateResult res = await local.updateCache(remoteData);

      int syncStatus = SyncLog.SYNC_STATUS_WARNING;
      String popupMsg = 'Tidak ada data yang diperbarui';
      String logMessage = 'Tidak ada data yang diperbarui';

      if (res.added > 0 || res.updated > 0 || res.deleted > 0) {
        syncStatus = SyncLog.SYNC_STATUS_SUCCESS;
        logMessage = 'Data berhasil di sinkronisasi';
        popupMsg = 'ditambahkan : ${res.added}, diubah : ${res.updated}, dihapus : ${res.deleted}';
      }

      // write to log
      logService.addLog(
        SyncLog(
          entity: 'user',
          status: syncStatus,
          message: logMessage,
          data: jsonEncode(res.toJson()),
          timestamp: DateTime.now(),
        ),
      );
      await AppDialog.show('Berhasil', content: popupMsg);

      users.value = local.getCachedUsers();
      update();
      // return users;
    } catch (e, stackTrace) {
      log("Error fetching users: $e", stackTrace: stackTrace);

      // write to log
      logService.addLog(
        SyncLog(
          entity: 'user',
          status: SyncLog.SYNC_STATUS_FAILED,
          message: 'Gagal sinkronisasi data user',
          data: e.toString(),
          timestamp: DateTime.now(),
        ),
      );
      await AppDialog.show('Terjadi kesalahan', content: 'Error: $e');
    }
  }
}
