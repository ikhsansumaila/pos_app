import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/core/network/response.dart';
import 'package:pos_app/modules/auth/auth_model.dart';
import 'package:pos_app/modules/auth/auth_repository.dart';
import 'package:pos_app/modules/home/menu.dart';
import 'package:pos_app/routes/routes.dart';
import 'package:pos_app/utils/constants/constant.dart';
import 'package:pos_app/utils/shared_preferences.dart';

class AuthController extends GetxController {
  final repository = Get.put(AuthRepository(Get.find()));

  @override
  void onInit() {
    log("onInit AuthController");
    super.onInit();
    _setUserDataFromLocal();
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
  UserLoginModel? _userLoginData;

  // TODO: remove this
  // sample_owner@gmail.com
  // ikhsan@gmail.com
  // kasir.ikhsan@gmail.com
  // ikhsan2@mail.com
  // ikhsan3@mail.com ========> SUPER ADMIN
  // ikhsan.customer@mail.com
  // password : 1234

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email dan password tidak boleh kosong");
      return;
    }

    isLoading.value = true;

    try {
      ApiResponse result = await repository.login({"email": email, "password": password});
      if (!result.isSuccess) {
        Get.snackbar(
          "Login Gagal",
          result.data['message'] ?? "Invalid username/password",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      Map<String, dynamic> jsonData = result.data['data'];
      await sharedPrefs.setKey(USER_LOGIN_SP_KEY, jsonEncode(jsonData)); // Save user login data
      _setUserLoginData(jsonEncode(jsonData)); // set variable _userLoginData

      Get.offAllNamed(AppRoutes.home.url);
    } catch (e) {
      log("Error: $e");
      isLoading.value = false;
      Get.snackbar("Error", "Terjadi kesalahan, silahkan coba lagi");
      return;
    }

    isLoading.value = false;
  }

  Future<void> logout() async {
    await sharedPrefs.remove(USER_LOGIN_SP_KEY);
    _setUserLoginData("");
    Get.offAllNamed(AppRoutes.login.url);
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void _setUserDataFromLocal() {
    String sharedPrefsData = sharedPrefs.getString(USER_LOGIN_SP_KEY);
    _setUserLoginData(sharedPrefsData);
  }

  void _setUserLoginData(String userLoginData) {
    if (userLoginData.isEmpty) {
      _userLoginData = null;
      return;
    }

    _userLoginData = UserLoginModel.fromJson(jsonDecode(userLoginData));
  }

  UserLoginModel? getUserLoginData() {
    return _userLoginData;
  }

  List<MenuItem> getUserMenu() {
    if (_userLoginData == null) {
      return [];
    }
    return HomeMenu.getMenuItem(_userLoginData!.role);
  }
}
