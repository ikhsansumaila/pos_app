import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pos_app/modules/cart/cart_controller.dart';
import 'package:pos_app/modules/cart/model/cart_item_model.dart';
import 'package:pos_app/modules/product/model/product_model.dart';
import 'package:pos_app/modules/product/product_contoller.dart';
import 'package:pos_app/modules/transaction/transaction_controller.dart';
import 'package:pos_app/routes.dart';
import 'package:pos_app/utils/constants/themes.dart';
import 'package:pos_app/utils/shared_preferences.dart';
import 'package:requests_inspector/requests_inspector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init shared prefs
  await sharedPrefs.init();

  // init hive (local database)
  await initHive();
  // await Hive.deleteFromDisk();

  Get.put(CartController());
  Get.put(ProductController());
  Get.put(TransactionController());

  final isLoggedIn = sharedPrefs.getBool('isLoggedIn');

  runApp(
    RequestsInspector(
      hideInspectorBanner: true,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login,
        getPages: AppRoutes.routes,
        theme: themes,
      ),
    ),
  );
}

Future<void> initHive() async {
  final dir = await getApplicationDocumentsDirectory();

  // Initialize Hivee
  Hive.init(dir.path);
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(CartItemModelAdapter());
}
