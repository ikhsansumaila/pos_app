import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pos_app/modules/cart/cart_controller.dart';
import 'package:pos_app/modules/cart/model/cart_item_model.dart';
import 'package:pos_app/modules/product/model/product_model.dart';
import 'package:pos_app/modules/product/product_contoller.dart';
import 'package:pos_app/routes.dart';
import 'package:requests_inspector/requests_inspector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();

  // Initialize Hivee
  Hive.init(dir.path);
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(CartItemModelAdapter());

  Get.put(CartController());
  Get.put(ProductController());

  runApp(
    RequestsInspector(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.home,
        getPages: AppRoutes.routes,
      ),
    ),
  );
}
