import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Username and password must not be empty");
      return;
    }

    isLoading.value = true;

    await Future.delayed(Duration(seconds: 1)); // simulate API delay

    if (username == "admin" && password == "1234") {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLoggedIn", true); // Save login flag
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.snackbar("Login Failed", "Invalid credentials");
    }

    isLoading.value = false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);
    Get.offAllNamed(AppRoutes.login);
  }
}
