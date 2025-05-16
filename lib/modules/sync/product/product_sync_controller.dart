import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:pos_app/core/network/connectivity_service.dart';
import 'package:pos_app/core/services/sync/log/sync_log_model.dart';
import 'package:pos_app/core/services/sync/log/sync_log_service.dart';
import 'package:pos_app/core/storage/local_storage_service.dart';
import 'package:pos_app/modules/common/widgets/app_dialog.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/modules/product/data/source/product_local.dart';
import 'package:pos_app/modules/product/data/source/product_remote.dart';

class ProductSyncController extends GetxController {
  final ProductLocalDataSource local;
  final ProductRemoteDataSource remote;
  final SyncLogService logService;
  final ConnectivityService connectivity;

  ProductSyncController({
    required this.local,
    required this.remote,
    required this.logService,
    required this.connectivity,
  });

  RxList<ProductModel> products = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    products.value = local.getCachedProducts();
    log("onInit ProductSyncController ${products.length}");
  }

  List<ProductModel> getProducts() {
    products.value = local.getCachedProducts();
    return products.toList();
  }

  Future<void> startSync(int storeId) async {
    final isOnline = await connectivity.isConnected();

    if (!isOnline) {
      await AppDialog.showErrorOffline();
      return;
    }

    try {
      final remoteData = await remote.fetchProducts(storeId);
      log("products fetched: ${remoteData.length}");
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
          entity: 'product',
          status: syncStatus,
          message: logMessage,
          data: jsonEncode(res.toJson()),
          timestamp: DateTime.now(),
        ),
      );
      await AppDialog.show('Berhasil', content: popupMsg);

      products.value = local.getCachedProducts();
      log("local.getCachedProducts() ${local.getCachedProducts()}");
      update();
      // return products;
    } catch (e, stackTrace) {
      log("Error fetching products: $e", stackTrace: stackTrace);

      // write to log
      logService.addLog(
        SyncLog(
          entity: 'product',
          status: SyncLog.SYNC_STATUS_FAILED,
          message: 'Gagal sinkronisasi data product',
          data: e.toString(),
          timestamp: DateTime.now(),
        ),
      );
      await AppDialog.show('Terjadi kesalahan', content: 'Error: $e');
    }
  }
}
