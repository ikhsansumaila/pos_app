import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pos_app/core/controller_provider.dart';
import 'package:pos_app/modules/sync/service/sync_service.dart';
import 'package:pos_app/modules/sync/sync_controller.dart';
import 'package:pos_app/modules/sync/sync_log/sync_log_service.dart';
import 'package:pos_app/modules/sync/sync_product/product_sync_controller.dart';
import 'package:pos_app/modules/sync/sync_transaction/transaction_queue_controller.dart';
import 'package:pos_app/modules/sync/sync_user/user_sync_controller.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

class SyncBinding extends Bindings {
  @override
  void dependencies() {
    // Syncronization Log
    var syncLogService = ControllerProvider.findOrPut(
      SyncLogService(logBox: Hive.box(SYNC_LOG_BOX_KEY)),
    );

    var userSyncController = ControllerProvider.findOrPut(
      UserSyncController(
        local: Get.find(), // init on app binding
        remote: Get.find(), // init on app binding
        logService: syncLogService,
        connectivity: Get.find(), // init on app binding
      ),
    );

    var productSyncController = ControllerProvider.findOrPut(
      ProductSyncController(
        local: Get.find(), // init on app binding
        remote: Get.find(), // init on app binding
        logService: syncLogService,
        connectivity: Get.find(), // init on app binding
      ),
    );

    var transactionQueueController = ControllerProvider.findOrPut(
      TransactionQueueController(
        local: Get.find(), // init on app binding
        remote: Get.find(), // init on app binding
        logService: syncLogService,
      ),
    );

    // Syncronization Service
    var syncService = ControllerProvider.findOrPut(
      SyncService(
        userSyncController: userSyncController,
        productSyncController: productSyncController,
        transactionQueueController: transactionQueueController,
        connectivity: Get.find(), // init on app binding
      ),
    );

    // Syncronization Controller
    Get.put(SyncController(syncService: syncService, logService: syncLogService));
  }
}
