// sync_service.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/core/network/connectivity_service.dart';
import 'package:pos_app/modules/sync/product/product_sync_controller.dart';
import 'package:pos_app/modules/sync/transaction/transaction_queue_controller.dart';
import 'package:pos_app/modules/sync/user/user_sync_controller.dart';
import 'package:pos_app/utils/constants/rest.dart';

class SyncService {
  // final UserQueueController userQueueController;
  final UserSyncController userSyncController;
  final ProductSyncController productSyncController;
  final TransactionQueueController transactionQueueController;
  final ConnectivityService connectivity;

  // bool isSyncing = false;
  DateTime? lastFailedSync;
  Timer? _retryTimer;

  SyncService({
    // required this.userQueueController,
    required this.userSyncController,
    required this.productSyncController,
    required this.transactionQueueController,
    required this.connectivity,
  });

  Future<void> syncAllWithDialog() async {
    // if (isSyncing) return;

    // isSyncing = true;
    // blocking screen (disable to edit)
    Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);

    await Future.delayed(Duration(seconds: 3));
    await _runSync();
    await _runQueue();

    // close blocking screen dialog
    Get.back();
    // isSyncing = false;

    // if (!success) {
    //   lastFailedSync = DateTime.now();

    //   Run Schedule retry
    //   _scheduleRetry();
    // }
  }

  Future<void> _runSync() async {
    try {
      final online = await connectivity.isConnected();
      if (!online) throw Exception("Offline");

      int storeId = 1;
      await userSyncController.startSync();
      await productSyncController.startSync(storeId);
    } catch (_) {}
  }

  Future<void> _runQueue() async {
    try {
      final online = await connectivity.isConnected();
      if (!online) throw Exception("Offline");

      // await userQueueController.processQueue();
      // await transactionQueueController.processQueue();
    } catch (_) {}
  }

  void _scheduleRetry() {
    _retryTimer?.cancel();
    _retryTimer = Timer(RETRY_SYNC_INTERVAL, () {
      if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
        syncAllWithDialog();
      }
    });
  }
}
