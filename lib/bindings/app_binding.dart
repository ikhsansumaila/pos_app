import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pos_app/core/network/connectivity_service.dart';
import 'package:pos_app/core/network/dio_client.dart';
import 'package:pos_app/modules/auth/auth_controller.dart';
import 'package:pos_app/modules/product/controller/product_contoller.dart';
import 'package:pos_app/modules/product/data/repository/product_repository.dart';
import 'package:pos_app/modules/product/data/repository/product_repository_impl.dart';
import 'package:pos_app/modules/product/data/source/product_local.dart';
import 'package:pos_app/modules/product/data/source/product_remote.dart';
import 'package:pos_app/modules/store/data/repository/store_repository.dart';
import 'package:pos_app/modules/store/data/repository/store_repository_impl.dart';
import 'package:pos_app/modules/store/data/source/store_local.dart';
import 'package:pos_app/modules/store/data/source/store_remote.dart';
import 'package:pos_app/modules/transaction/order/data/repository/order_repository.dart';
import 'package:pos_app/modules/transaction/order/data/repository/order_repository_impl.dart';
import 'package:pos_app/modules/transaction/order/data/source/order_local.dart';
import 'package:pos_app/modules/transaction/order/data/source/order_remote.dart';
import 'package:pos_app/modules/transaction/selling/controller/transaction_controller.dart';
import 'package:pos_app/modules/transaction/selling/data/repository/transaction_repository.dart';
import 'package:pos_app/modules/transaction/selling/data/repository/transaction_respository_impl.dart';
import 'package:pos_app/modules/transaction/selling/data/source/transaction_local.dart';
import 'package:pos_app/modules/transaction/selling/data/source/transaction_remote.dart';
import 'package:pos_app/modules/user/controller/user_controller.dart';
import 'package:pos_app/modules/user/data/repository/user_repository.dart';
import 'package:pos_app/modules/user/data/repository/user_repository_impl.dart';
import 'package:pos_app/modules/user/data/source/user_local.dart';
import 'package:pos_app/modules/user/data/source/user_remote.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Inject Network
    Get.put(DioClient());
    Get.put(ConnectivityService());

    // Inject Local, Remote Storages, and Repository (Hive box is open in main)
    putDataStorages();

    // Inject Controller
    putController();
  }

  // Inject Queue Controller
  // putSyncController();

  // Syncronization data to server, run in background/manual mode
  // Get.put(
  //   SyncService(
  //     userSyncController: Get.find(),
  //     productSyncController: Get.find(),
  //     // userQueueController: Get.find(),
  //     transactionQueueController: Get.find(),
  //     connectivity: Get.find(),
  //   ),
  // );
  // }

  void putDataStorages() {
    // Local Storage (Hive box is open in main)
    Get.put(
      UserLocalDataSource(
        userCacheBox: Hive.box(USER_BOX_KEY),
        roleCacheBox: Hive.box(USER_ROLE_BOX_KEY),
      ),
    );
    Get.put(StoreLocalDataSource(cacheBox: Hive.box(STORE_BOX_KEY)));
    Get.put(ProductLocalDataSource(cacheBox: Hive.box(PRODUCT_BOX_KEY)));
    Get.put(OrderLocalDataSource(cacheBox: Hive.box(ORDER_BOX_KEY)));
    Get.put(
      TransactionLocalDataSource(
        cacheBox: Hive.box(TRANSACTION_BOX_KEY),
        queueBox: Hive.box(QUEUE_TRANSACTION_KEY),
      ),
    );

    // Remote Storage
    Get.put(UserRemoteDataSource(dio: Get.find()));
    Get.put(StoreRemoteDataSource(dio: Get.find()));
    Get.put(ProductRemoteDataSource(dio: Get.find()));
    Get.put(TransactionRemoteDataSource(dio: Get.find()));
    Get.put(OrderRemoteDataSource(dio: Get.find()));

    // Repository
    Get.put<UserRepository>(
      UserRepositoryImpl(local: Get.find(), remote: Get.find(), connectivity: Get.find()),
    );
    Get.put<StoreRepository>(
      StoreRepositoryImpl(local: Get.find(), remote: Get.find(), connectivity: Get.find()),
    );
    Get.put<ProductRepository>(
      ProductRepositoryImpl(local: Get.find(), remote: Get.find(), connectivity: Get.find()),
    );
    Get.put<TransactionRepository>(
      TransactionRepositoryImpl(local: Get.find(), remote: Get.find(), connectivity: Get.find()),
    );
    Get.put<OrderRepository>(
      OrderRepositoryImpl(local: Get.find(), remote: Get.find(), connectivity: Get.find()),
    );
  }

  void putController() {
    Get.put(AuthController());
    Get.put(UserController(repository: Get.find()));
    Get.put(ProductController(repository: Get.find()));
    Get.put(TransactionController(repository: Get.find()));
  }
}
