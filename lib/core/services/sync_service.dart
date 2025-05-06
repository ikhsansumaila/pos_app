// sync_service.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/core/network/connectivity_service.dart';
import 'package:pos_app/core/services/sync_log_service.dart';
import 'package:pos_app/data/models/sync_log_model.dart';
import 'package:pos_app/data/repository/order/order_repository.dart';
import 'package:pos_app/data/repository/product/product_repository.dart';

class SyncService {
  final ProductRepository productRepo;
  final OrderRepository orderRepo;
  final SyncLogService logService;
  final ConnectivityService connectivity;

  bool isSyncing = false;
  DateTime? lastFailedSync;
  Timer? _retryTimer;

  SyncService({
    required this.productRepo,
    required this.orderRepo,
    required this.logService,
    required this.connectivity,
  });

  Future<void> syncAllWithDialog() async {
    if (isSyncing) return;

    isSyncing = true;
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final success = await _syncWithTimeout(Duration(seconds: 10));
    Get.back();
    isSyncing = false;

    if (!success) {
      lastFailedSync = DateTime.now();
      _scheduleRetry();
    }
  }

  Future<bool> _syncWithTimeout(Duration timeout) async {
    try {
      final online = await connectivity.isConnected();
      if (!online) throw Exception("Offline");

      // Product
      final prodSuccess = await productRepo.processQueue();
      logService.addLog(
        SyncLog(
          type: 'product',
          success: prodSuccess,
          message: prodSuccess ? 'Products synced' : 'Failed syncing products',
          timestamp: DateTime.now(),
        ),
      );

      // Order
      final orderSuccess = await orderRepo.processQueue();
      logService.addLog(
        SyncLog(
          type: 'order',
          success: orderSuccess,
          message: orderSuccess ? 'Orders synced' : 'Failed syncing orders',
          timestamp: DateTime.now(),
        ),
      );

      return prodSuccess && orderSuccess;
    } catch (_) {
      return false;
    }
  }

  void _scheduleRetry() {
    _retryTimer?.cancel();
    _retryTimer = Timer(Duration(minutes: 10), () {
      if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
        syncAllWithDialog();
      }
    });
  }
}
