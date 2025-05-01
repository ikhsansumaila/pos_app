import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/routes.dart';
import 'package:requests_inspector/requests_inspector.dart';

void main() {
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
