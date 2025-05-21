import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/auth/auth_repository.dart';
import 'package:pos_app/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  String role;
  String route;

  UserData({required this.role, required this.route});
}

class AuthController extends GetxController {
  final repository = Get.put(AuthRepository(Get.find()));

  @override
  void onInit() {
    log("onInit AuthController");
    super.onInit();
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  // final Map<String, UserData> userData = {
  //   "admin": UserData(role: "admin", route: AppRoutes.home.url),
  //   "pelanggan": UserData(role: "pelanggan", route: AppRoutes.home.url),
  //   "kasir": UserData(role: "kasir", route: AppRoutes.home.url),
  // };

  // TODO: remove this
  // sample_owner@gmail.com
  // ikhsan@gmail.com
  // kasir.ikhsan@gmail.com
  // ikhsan2@mail.com
  // ikhsan3@mail.com
  // ikhsan.customer@mail.com
  // password : 1234

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    // final role = userData[username]!.role;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email dan password tidak boleh kosong");
      return;
    }

    isLoading.value = true;

    var result = await repository.login({"email": email, "password": password});

    log('login result: ${result.toString()}');
    if (!result.isSuccess) {
      Get.snackbar("Login Failed", result.data['message'] ?? "Invalid username/password");
      isLoading.value = false;
      return;
    }
    // final role = result.data['role'] ?? "admin"; // Default to admin if not found
    // Future.delayed(Duration(seconds: 1)); // simulate API delay

    // if (!userData.containsKey(username)) {
    //   Get.snackbar("Login Failed", "Invalid username/password");
    //   isLoading.value = false;
    //   return;
    // }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", true); // Save login flag
    await prefs.setString("role", 'admin');

    Get.offAllNamed(AppRoutes.home.url);

    isLoading.value = false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool("isLoggedIn", false);
    await prefs.remove("role");

    Get.offAllNamed(AppRoutes.login.url);
  }
}
