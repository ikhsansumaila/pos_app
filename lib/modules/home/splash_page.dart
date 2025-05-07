// lib/modules/splash/splash_page.dart

import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final hiveController = Get.find<HiveController>();

    // return Obx(() {
    //   if (hiveController.isReady.value) {
    //     // Langsung navigasi begitu siap
    //     Future.microtask(() {
    //       final isLoggedIn = sharedPrefs.getBool('isLoggedIn');
    //       Get.offAllNamed(isLoggedIn ? AppRoutes.home : AppRoutes.login);
    //     });

    //     return SizedBox(); // Kosong sementara transisi
    //   }

    return Scaffold(body: Center(child: CircularProgressIndicator()));
    // });
  }
}
