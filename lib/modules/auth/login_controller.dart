import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  String role;
  String route;

  UserData({required this.role, required this.route});
}

class AuthController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  final Map<String, UserData> userData = {
    "admin": UserData(role: "admin", route: AppRoutes.home.url),
    "pelanggan": UserData(role: "pelanggan", route: AppRoutes.home.url),
    "kasir": UserData(role: "kasir", route: AppRoutes.home.url),
  };

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;
    final role = userData[username]!.role;

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Username and password must not be empty");
      return;
    }

    isLoading.value = true;

    await Future.delayed(Duration(seconds: 1)); // simulate API delay

    if (!userData.containsKey(username)) {
      Get.snackbar("Login Failed", "Invalid credentials");
      isLoading.value = false;
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", true); // Save login flag
    await prefs.setString("role", role);

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
