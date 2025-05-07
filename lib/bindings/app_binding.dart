import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pos_app/core/network/connectivity_service.dart';
import 'package:pos_app/core/network/dio_client.dart';
import 'package:pos_app/core/services/sync_log_service.dart';
import 'package:pos_app/core/services/sync_queue_service.dart';
import 'package:pos_app/data/repository/order/order_repository.dart';
import 'package:pos_app/data/repository/order/order_repository_impl.dart';
import 'package:pos_app/data/repository/order/source/order_local.dart';
import 'package:pos_app/data/repository/order/source/order_remote.dart';
import 'package:pos_app/data/repository/product/product_repository.dart';
import 'package:pos_app/data/repository/product/product_repository_impl.dart';
import 'package:pos_app/data/repository/product/source/product_local.dart';
import 'package:pos_app/data/repository/product/source/product_remote.dart';
import 'package:pos_app/modules/auth/login_controller.dart';
import 'package:pos_app/modules/product/product_contoller.dart';
import 'package:pos_app/modules/transaction/purchase_order/order_controller.dart';
import 'package:pos_app/modules/transaction/transaction_cashier/transaction_controller.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Inject Network
    Get.put(DioClient());
    Get.put(ConnectivityService());

    // Inject Local Storage, Hive box is open in main
    Get.put(ProductLocalDataSource(Hive.box(PRODUCT_BOX_KEY)));
    Get.put(OrderLocalDataSource(Hive.box(ORDER_BOX_KEY)));
    Get.put(SyncLogService(Hive.box(SYNC_LOG_BOX_KEY)));

    // Inject Remote Storage
    Get.put(ProductRemoteDataSource(Get.find()));
    Get.put(OrderRemoteDataSource(Get.find()));

    // Inject Repository
    Get.put<ProductRepository>(
      ProductRepositoryImpl(Get.find(), Get.find(), Get.find()),
    );
    Get.put<OrderRepository>(
      OrderRepositoryImpl(Get.find(), Get.find(), Get.find()),
    );

    // Inject Controller
    Get.put(AuthController());
    Get.put(ProductController(Get.find()));
    Get.put(OrdersController());
    Get.put(TransactionController());

    // Syncronization data to server, run in background
    Get.lazyPut(
      () => SyncQueueService(
        productRepo: Get.find(),
        orderRepo: Get.find(),
        logService: Get.find(),
        connectivity: Get.find(),
      ),
    );
  }
}
