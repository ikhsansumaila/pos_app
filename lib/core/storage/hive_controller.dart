// // lib/controllers/app_controller.dart

// import 'package:get/get.dart';
// import 'package:hive/hive.dart';
// import 'package:pos_app/core/services/sync_log_service.dart';
// import 'package:pos_app/data/repository/order/source/order_local.dart';
// import 'package:pos_app/data/repository/product/source/product_local.dart';
// import 'package:pos_app/utils/constants/hive_key.dart';

// class HiveController extends GetxController {
//   var isReady = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _initHiveBoxes();
//   }

//   Future<void> _initHiveBoxes() async {
//     await Future.wait([
//       Hive.openBox(PRODUCT_BOX_KEY),
//       Hive.openBox(ORDER_BOX_KEY),
//       Hive.openBox(SYNC_LOG_BOX_KEY),
//     ]);

//     // Inject Local Storage
//     Get.put(ProductLocalDataSource(Hive.box(PRODUCT_BOX_KEY))); // open in main
//     Get.put(OrderLocalDataSource(Hive.box(ORDER_BOX_KEY))); // open in main
//     Get.put(SyncLogService(Hive.box(SYNC_LOG_BOX_KEY))); // open in main

//     isReady.value = true;
//   }
// }
