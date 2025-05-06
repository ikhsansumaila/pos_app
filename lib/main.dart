import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pos_app/bindings/app_binding.dart';
import 'package:pos_app/data/models/product_model.dart';
import 'package:pos_app/modules/cart/model/cart_item_model.dart';
import 'package:pos_app/routes.dart';
import 'package:pos_app/utils/constants/hive_key.dart';
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

  final isLoggedIn = sharedPrefs.getBool('isLoggedIn');

  runApp(
    RequestsInspector(
      hideInspectorBanner: true,
      child: GetMaterialApp(
        initialBinding: AppBinding(),
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

  // Open Hive Boxes (MUST BE WAITED ON INIT)
  await Hive.openBox(PRODUCT_BOX_KEY); // will use on AppBinding
  await Hive.openBox(ORDER_BOX_KEY); // will use on AppBinding
  await Hive.openBox(SYNC_LOG_BOX_KEY); // will use on AppBinding
}
