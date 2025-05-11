import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pos_app/core/network/connectivity_service.dart';
import 'package:pos_app/core/network/dio_client.dart';
import 'package:pos_app/core/services/sync/queue/sync_queue_service.dart';
import 'package:pos_app/core/services/sync/sync_log_service.dart';
import 'package:pos_app/modules/auth/login_controller.dart';
import 'package:pos_app/modules/cart/cart_controller.dart';
import 'package:pos_app/modules/product/controller/product_contoller.dart';
import 'package:pos_app/modules/product/data/repository/product_repository.dart';
import 'package:pos_app/modules/product/data/repository/product_repository_impl.dart';
import 'package:pos_app/modules/product/data/source/product_local.dart';
import 'package:pos_app/modules/product/data/source/product_remote.dart';
import 'package:pos_app/modules/sync/user/user_queue_controller.dart';
import 'package:pos_app/modules/transaction/main/controller/transaction_controller.dart';
import 'package:pos_app/modules/transaction/main/data/repository/transaction_repository.dart';
import 'package:pos_app/modules/transaction/main/data/repository/transaction_respository_impl.dart';
import 'package:pos_app/modules/transaction/main/data/source/transaction_local.dart';
import 'package:pos_app/modules/transaction/main/data/source/transaction_remote.dart';
import 'package:pos_app/modules/transaction/order/data/repository/order_repository.dart';
import 'package:pos_app/modules/transaction/order/data/repository/order_repository_impl.dart';
import 'package:pos_app/modules/transaction/order/data/source/order_local.dart';
import 'package:pos_app/modules/transaction/order/data/source/order_remote.dart';
import 'package:pos_app/modules/transaction/order/order_controller.dart';
import 'package:pos_app/modules/user/controller/user_controller.dart';
import 'package:pos_app/modules/user/data/repository/user_repository.dart';
import 'package:pos_app/modules/user/data/repository/user_repository_impl.dart';
import 'package:pos_app/modules/user/data/source/user_local.dart';
import 'package:pos_app/modules/user/data/source/user_remote.dart';
import 'package:pos_app/utils/constants/controller_tag.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Inject Network
    Get.put(DioClient());
    Get.put(ConnectivityService());

    // Inject Local Storage, Hive box is open in main
    putLocalStorage();

    // Inject Remote Storage
    putRemoteStorage();

    // Inject Repository
    putRepository();

    // Inject Controller
    putController();

    // Inject Queue
    putQueue();

    // Inject Sync Log
    Get.put(SyncLogService(Hive.box(SYNC_LOG_BOX_KEY)));

    // Syncronization data to server, run in background
    Get.put(
      SyncQueueService(
        userRepo: Get.find(),
        transactionRepository: Get.find(),
        productRepo: Get.find(),
        orderRepo: Get.find(),
        logService: Get.find(),
        connectivity: Get.find(),
      ),
    );
  }

  void putLocalStorage() {
    Get.put(
      UserLocalDataSource(Hive.box(USER_BOX_KEY), Hive.box(QUEUE_USER_KEY)),
    );
    Get.put(
      ProductLocalDataSource(
        Hive.box(PRODUCT_BOX_KEY),
        Hive.box(QUEUE_PRODUCT_KEY),
      ),
    );
    Get.put(
      OrderLocalDataSource(Hive.box(ORDER_BOX_KEY), Hive.box(QUEUE_ORDER_KEY)),
    );
    Get.put(
      TransactionLocalDataSource(
        Hive.box(TRANSACTION_BOX_KEY),
        Hive.box(QUEUE_TRANSACTION_KEY),
      ),
    );
  }

  void putRemoteStorage() {
    Get.put(UserRemoteDataSource(Get.find()));
    Get.put(ProductRemoteDataSource(Get.find()));
    Get.put(TransactionRemoteDataSource(Get.find()));
    Get.put(OrderRemoteDataSource(Get.find()));
  }

  void putQueue() {
    Get.put<UserQueueController>(
      UserQueueController(Get.find()),
      tag: USER_CONTROLLER_TAG,
    );
  }

  void putRepository() {
    Get.put<UserRepository>(
      UserRepositoryImpl(Get.find(), Get.find(), Get.find()),
    );
    Get.put<ProductRepository>(
      ProductRepositoryImpl(Get.find(), Get.find(), Get.find()),
    );
    Get.put<TransactionRepository>(
      TransactionRepositoryImpl(Get.find(), Get.find(), Get.find()),
    );
    Get.put<OrderRepository>(
      OrderRepositoryImpl(Get.find(), Get.find(), Get.find()),
    );
  }

  void putController() {
    Get.put(AuthController());
    Get.put(UserController(Get.find()));
    Get.put(ProductController(Get.find()));
    Get.put(OrdersController());
    Get.put(TransactionController());
    Get.put(CartController());
  }
}
