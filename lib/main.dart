import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pos_app/bindings/app_binding.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/modules/store/data/models/store_model.dart';
import 'package:pos_app/modules/transaction/common/models/transaction_create_model.dart';
import 'package:pos_app/modules/transaction/common/models/transaction_model.dart';
import 'package:pos_app/modules/transaction/order/data/models/order_model.dart';
import 'package:pos_app/modules/user/data/models/user_model.dart';
import 'package:pos_app/modules/user/data/models/user_role_model.dart';
import 'package:pos_app/routes/routes.dart';
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

  final isLoggedIn = sharedPrefs.getBool('isLoggedIn');

  runApp(
    RequestsInspector(
      hideInspectorBanner: true,
      child: GetMaterialApp(
        initialBinding: AppBinding(),
        debugShowCheckedModeBanner: false,
        initialRoute: isLoggedIn ? AppRoutes.home.url : AppRoutes.login.url,
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

  // Register Hive Adapters
  registerHiveAdapters();

  // Delete Hive Boxes, for testing purpose
  await deleteBoxes();

  // Open Hive Boxes (MUST BE WAITED ON INIT)
  await openBoxes();
}

void registerHiveAdapters() {
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(UserRoleModelAdapter());
  Hive.registerAdapter(StoreModelAdapter());
  // Hive.registerAdapter(UserCreateModelAdapter());
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(TransactionCreateModelAdapter());
  Hive.registerAdapter(OrderModelAdapter());
}

Future<void> openBoxes() async {
  await Hive.openBox(USER_BOX_KEY); // will use on AppBinding
  await Hive.openBox(USER_ROLE_BOX_KEY); // will use on AppBinding
  await Hive.openBox(STORE_BOX_KEY); // will use on AppBinding
  await Hive.openBox(PRODUCT_BOX_KEY); // will use on AppBinding
  await Hive.openBox(TRANSACTION_BOX_KEY); // will use on AppBinding
  await Hive.openBox(ORDER_BOX_KEY); // will use on AppBinding
  await Hive.openBox(SYNC_LOG_BOX_KEY); // will use on AppBinding

  // queue post data to server
  // await Hive.openBox(QUEUE_USER_KEY); // will use on AppBinding
  // await Hive.openBox(QUEUE_STORE_KEY); // will use on AppBinding
  // await Hive.openBox(QUEUE_PRODUCT_KEY); // will use on AppBinding
  // await Hive.openBox(QUEUE_ORDER_KEY); // will use on AppBinding
  await Hive.openBox(QUEUE_TRANSACTION_KEY); // will use on AppBinding
}

Future<void> deleteBoxes() async {
  await Hive.deleteBoxFromDisk(USER_BOX_KEY);
  await Hive.deleteBoxFromDisk(USER_ROLE_BOX_KEY);
  await Hive.deleteBoxFromDisk(STORE_BOX_KEY);
  await Hive.deleteBoxFromDisk(PRODUCT_BOX_KEY);
  await Hive.deleteBoxFromDisk(TRANSACTION_BOX_KEY);
  await Hive.deleteBoxFromDisk(ORDER_BOX_KEY);
  await Hive.deleteBoxFromDisk(SYNC_LOG_BOX_KEY);

  // queue post data to server
  // await Hive.deleteBoxFromDisk(QUEUE_USER_KEY);
  // await Hive.deleteBoxFromDisk(QUEUE_STORE_KEY);
  // await Hive.deleteBoxFromDisk(QUEUE_PRODUCT_KEY);
  // await Hive.deleteBoxFromDisk(QUEUE_ORDER_KEY);
  await Hive.deleteBoxFromDisk(QUEUE_TRANSACTION_KEY);
}
