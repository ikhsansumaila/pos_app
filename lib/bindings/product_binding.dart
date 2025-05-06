import 'package:get/get.dart';
import 'package:pos_app/data/repository/product/product_repository_impl.dart';
import 'package:pos_app/data/source/product/local.dart';
import 'package:pos_app/data/source/product/remote.dart';
import 'package:pos_app/modules/product/product_contoller.dart';

class ProductBinding extends Bindings {
  final String BASE_URL = 'https://esiportal.com';
  @override
  void dependencies() {
    // Get.lazyPut(() => Dio(BaseOptions(baseUrl: BASE_URL)));
    // Get.lazyPut(() => ConnectivityService());
    // Get.lazyPut(() async {
    //   await Hive.initFlutter();
    //   return await Hive.openBox('productBox');
    // });

    Get.lazyPut(() => ProductRemoteDataSource(Get.find()));
    Get.lazyPut(() => ProductLocalDataSource());
    Get.lazyPut(
      () => ProductRepositoryImpl(Get.find(), Get.find(), Get.find()),
    );
    Get.lazyPut(() => ProductController(Get.find()));
  }
}
