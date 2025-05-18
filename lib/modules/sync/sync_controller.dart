import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/sync/detail/sync_product/product_sync_detail.dart';
import 'package:pos_app/modules/sync/detail/sync_transaction/transaction_queue_detail.dart';
import 'package:pos_app/modules/sync/detail/sync_user/user_sync_detail_page.dart';
import 'package:pos_app/modules/sync/service/sync_service.dart';
import 'package:pos_app/modules/sync/sync_log/sync_log_model.dart';
import 'package:pos_app/modules/sync/sync_log/sync_log_service.dart';

class SyncEntitiesModel<T> {
  final String title;
  final Widget detailPage;
  SyncEntitiesModel({required this.title, required this.detailPage});
}

class SyncController extends GetxController {
  final SyncLogService logService;
  final SyncService syncService;

  var logs = <SyncLog>[].obs;
  var exporting = false.obs;
  var syncing = false.obs;

  List<SyncEntitiesModel> entities = [
    //   SyncEntitiesModel(title: 'Data User', detailPage: UserQueueDetailPage()),
    SyncEntitiesModel(title: 'Data User', detailPage: UserSyncDetailPage()),
    SyncEntitiesModel(title: 'Data Barang', detailPage: ProductSyncDetailPage()),
    SyncEntitiesModel(title: 'Data Transaksi', detailPage: TransactionQueueDetail()),
  ];

  SyncController({required this.logService, required this.syncService});

  @override
  void onInit() {
    super.onInit();
    loadLogs();
  }

  void loadLogs() {
    logs.value = logService.getAllLogs().reversed.toList();
  }

  void refreshLogs() {
    loadLogs();
  }

  Future<void> exportLogs() async {
    exporting.value = true;
    final path = await logService.exportLogsAsTxt();
    exporting.value = false;
    Get.snackbar('Export Log', 'Disimpan di: $path');
  }

  Future<void> manualSync() async {
    syncing.value = true;
    await syncService.syncAllWithDialog();
    syncing.value = false;
    loadLogs(); // Refresh log setelah sync
  }
}
