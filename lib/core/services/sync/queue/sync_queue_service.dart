// sync_service.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/core/network/connectivity_service.dart';
import 'package:pos_app/modules/sync/transaction/transaction_queue_controller.dart';
import 'package:pos_app/modules/sync/user/user_queue_controller.dart';
import 'package:pos_app/utils/constants/rest.dart';

class SyncQueueService {
  final UserQueueController userQueueController;
  final TransactionQueueController transactionQueueController;
  final ConnectivityService connectivity;

  bool isSyncing = false;
  DateTime? lastFailedSync;
  Timer? _retryTimer;

  SyncQueueService({
    required this.userQueueController,
    required this.transactionQueueController,
    required this.connectivity,
  });

  Future<void> syncAllWithDialog() async {
    if (isSyncing) return;

    isSyncing = true;
    Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);

    await Future.delayed(Duration(seconds: 3));
    await _syncWithTimeout(TIMEOUT_DURATION);

    Get.back();
    isSyncing = false;

    // if (!success) {
    //   lastFailedSync = DateTime.now();

    // Run Schedule retry
    // _scheduleRetry();
    // }
  }

  Future<void> _syncWithTimeout(Duration timeout) async {
    try {
      final online = await connectivity.isConnected();
      if (!online) throw Exception("Offline");

      // Users
      // await userQueueController.processQueue();
      await transactionQueueController.processQueue();
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
