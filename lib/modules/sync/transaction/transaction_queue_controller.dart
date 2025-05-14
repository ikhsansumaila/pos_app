import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/core/services/sync/log/sync_log_model.dart';
import 'package:pos_app/core/services/sync/log/sync_log_service.dart';
import 'package:pos_app/modules/common/widgets/snackbar.dart';
import 'package:pos_app/modules/transaction/main/data/models/transaction_create_model.dart';
import 'package:pos_app/modules/transaction/main/data/source/transaction_local.dart';
import 'package:pos_app/modules/transaction/main/data/source/transaction_remote.dart';

class TransactionQueueController extends GetxController {
  final TransactionLocalDataSource local;
  final TransactionRemoteDataSource remote;
  final SyncLogService logService;

  TransactionQueueController({required this.local, required this.remote, required this.logService});

  List<TransactionCreateModel> getQueuedItems() {
    return local.getQueuedItems();
  }

  Future<void> rePostAllItems(List<TransactionCreateModel> items) async {
    int totalFailed = 0;
    int totalSuccess = 0;

    Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);

    // for (var item in items) {
    for (int i = 0; i < items.length; i++) {
      var item = items[i];
      var response = await remote.postTransaction(item.toJson());
      bool isSuccess = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccess) {
        await local.deleteQueueAt(i); // Hapus data yg sukses
        totalSuccess++;
      } else {
        totalFailed++;
      }

      logService.addLog(
        SyncLog(
          type: 'transaction',
          success: isSuccess,
          message: isSuccess ? 'Transactions synced' : 'Failed syncing transactions',
          data: response.data,
          timestamp: DateTime.now(),
        ),
      );
    }

    Get.back();
    Get.snackbar(
      'Sinkronisasi Selesai',
      'Berhasil sinkronisasi $totalSuccess data, gagal sinkronisasi $totalFailed data',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> rePostItem(TransactionCreateModel item, int queueIndex) async {
    Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);

    var response = await remote.postTransaction(item.toJson());
    bool isSuccess = response.statusCode == 200 || response.statusCode == 201;
    if (isSuccess) {
      await local.deleteQueueAt(queueIndex); // Hapus data yg sukses
    }

    // write to log
    logService.addLog(
      SyncLog(
        type: 'transaction',
        success: isSuccess,
        message: isSuccess ? 'Transactions synced' : 'Failed syncing transactions',
        data: response.data,
        timestamp: DateTime.now(),
      ),
    );

    Get.back();
    AppSnackbar.showSyncResultSnackbar(
      isSuccess: response.statusCode == 200 || response.statusCode == 201,
    );
  }

  Future<void> processQueue() async {
    // TODO: ADD BULKING POST and call clearAllQueue after ?

    final queue = local.getQueuedItems(); // dari Hive

    if (queue.isEmpty) return;

    for (int i = 0; i < queue.length; i++) {
      try {
        final item = queue[i]; // send FIFO

        // Re-send pending data
        log('trying to send ${item.toJson()}');
        var response = await remote.postTransaction(item.toJson());
        bool isSuccess = response.statusCode == 200 || response.statusCode == 201;

        // Jika berhasil, hapus data dari queue
        if (isSuccess) {
          await local.deleteQueueAt(i); // Hapus data yg sukses
        }

        // write to log
        logService.addLog(
          SyncLog(
            type: 'transaction',
            success: isSuccess,
            message: isSuccess ? 'Transactions synced' : 'Failed syncing transactions',
            data: response.data,
            timestamp: DateTime.now(),
          ),
        );
      } catch (e) {
        // Jika gagal lagi, data tetap ada di queue
        // write to log
        logService.addLog(
          SyncLog(
            type: 'transaction',
            success: false,
            message: 'Failed syncing transactions',
            data: e.toString(),
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }
}
