import 'package:get/get.dart';
import 'package:pos_app/modules/transaction/select_item/transaction_controller.dart';

class TransactionBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => Dio(BaseOptions(baseUrl: BASE_URL)));
    // Get.lazyPut(() => ConnectivityService());
    // Get.lazyPut(() async {
    //   await Hive.initFlutter();
    //   return await Hive.openBox('productBox');
    // });
    // Get.lazyPut(() => ProductRemoteDataSource(Get.find()));
    // Get.lazyPut(() => ProductLocalDataSource(Get.find()));
    // Get.lazyPut(
    //   () => ProductRepositoryImpl(Get.find(), Get.find(), Get.find()),
    // );
    // Get.lazyPut(() => ProductController(Get.find()));

    // TODO: IT WORKS, USE THIS OR ON APP BINDING
    // Get.put(ProductRemoteDataSource(Get.find()));
    // Get.put(ProductLocalDataSource());
    // Get.put<ProductRepository>(
    //   ProductRepositoryImpl(Get.find(), Get.find(), Get.find()),
    // );
    // Get.put(ProductController(Get.find()));
    Get.put(TransactionController());
  }
}
