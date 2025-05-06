import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pos_app/core/network/connectivity_service.dart';
import 'package:pos_app/data/repository/product/product_repository.dart';
import 'package:pos_app/data/repository/product/product_repository_impl.dart';
import 'package:pos_app/data/source/product/local.dart';
import 'package:pos_app/data/source/product/remote.dart';
import 'package:pos_app/modules/product/product_contoller.dart';

class AppBinding extends Bindings {
  final String BASE_URL = 'https://esiportal.com';

  @override
  void dependencies() {
    // Dio, Hive, Repository
    Get.put(Dio(BaseOptions(baseUrl: BASE_URL)));
    Get.put(ConnectivityService());
    // Get.lazyPut(() => ConnectivityService());

    // Get.lazyPut(() async {
    //   await Hive.initFlutter();
    //   final logBox = await Hive.openBox(SYNC_LOG_BOX_KEY);
    //   return SyncLogService(logBox);
    // });

    // Sinkronisasi
    // Get.lazyPut(
    //   () => SyncService(
    //     productRepo: Get.find(),
    //     orderRepo: Get.find(),
    //     logService: Get.find(),
    //     connectivity: Get.find(),
    //   ),
    // );
    // // existing run project
    // Get.put(TransactionController());

    Get.put(ProductRemoteDataSource(Get.find()));
    Get.put(ProductLocalDataSource());
    Get.put<ProductRepository>(
      ProductRepositoryImpl(Get.find(), Get.find(), Get.find()),
    );
    Get.put(ProductController(Get.find()));
  }
}
