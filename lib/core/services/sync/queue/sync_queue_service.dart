// sync_service.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/core/network/connectivity_service.dart';
import 'package:pos_app/core/services/sync/log/sync_log_model.dart';
import 'package:pos_app/core/services/sync/log/sync_log_service.dart';
import 'package:pos_app/modules/product/data/repository/product_repository.dart';
import 'package:pos_app/modules/transaction/main/data/repository/transaction_repository.dart';
import 'package:pos_app/modules/transaction/order/data/repository/order_repository.dart';
import 'package:pos_app/modules/user/data/repository/user_repository.dart';
import 'package:pos_app/utils/constants/constant.dart';

class SyncQueueService {
  final UserRepository userRepo;
  final ProductRepository productRepo;
  final TransactionRepository transactionRepository;
  final OrderRepository orderRepo;
  final SyncLogService logService;
  final ConnectivityService connectivity;

  bool isSyncing = false;
  DateTime? lastFailedSync;
  Timer? _retryTimer;

  SyncQueueService({
    required this.userRepo,
    required this.productRepo,
    required this.transactionRepository,
    required this.orderRepo,
    required this.logService,
    required this.connectivity,
  });

  Future<void> syncAllWithDialog() async {
    if (isSyncing) return;

    isSyncing = true;
    Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);

    await Future.delayed(Duration(seconds: 3));

    final success = await _syncWithTimeout(TIMEOUT_DURATION);
    Get.back();
    isSyncing = false;

    if (!success) {
      lastFailedSync = DateTime.now();

      // Run Schedule retry
      // _scheduleRetry();
    }
  }

  Future<bool> _syncWithTimeout(Duration timeout) async {
    try {
      final online = await connectivity.isConnected();
      if (!online) throw Exception("Offline");

      // Users
      final userSuccess = await userRepo.processQueue();
      logService.addLog(
        SyncLog(
          type: 'user',
          success: userSuccess,
          message: userSuccess ? 'Users synced' : 'Failed syncing users',
          data: '',
          timestamp: DateTime.now(),
        ),
      );

      return userSuccess;

      // Product
      // final prodSuccess = await productRepo.processQueue();
      // logService.addLog(
      //   SyncLog(
      //     type: 'product',
      //     success: prodSuccess,
      //     message: prodSuccess ? 'Products synced' : 'Failed syncing products',
      //     timestamp: DateTime.now(),
      //   ),
      // );

      // // Transaction
      // final trxSuccess = await productRepo.processQueue();
      // logService.addLog(
      //   SyncLog(
      //     type: 'transaction',
      //     success: trxSuccess,
      //     message: trxSuccess ? 'Transactions synced' : 'Failed syncing transactions',
      //     timestamp: DateTime.now(),
      //   ),
      // );

      // // Order
      // final orderSuccess = await orderRepo.processQueue();
      // logService.addLog(
      //   SyncLog(
      //     type: 'order',
      //     success: orderSuccess,
      //     message: orderSuccess ? 'Orders synced' : 'Failed syncing orders',
      //     timestamp: DateTime.now(),
      //   ),
      // );

      // return prodSuccess && orderSuccess;
    } catch (_) {
      return false;
    }
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
