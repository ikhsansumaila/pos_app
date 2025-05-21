import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/auth/auth_controller.dart';
import 'package:pos_app/modules/auth/login_page.dart';
import 'package:pos_app/modules/home/admin/admin_home_page.dart';
import 'package:pos_app/modules/home/cashier/cashier_home_page.dart';
import 'package:pos_app/modules/home/customer/customer_home_page.dart';
import 'package:pos_app/utils/shared_preferences.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    String role = sharedPrefs.getString('role');
    log("role $role");

    bool isAdmin = role == 'admin' || role == 'super admin';
    bool isCashier = role == 'kasir';
    bool isCustomer = role == 'pelanggan';

    if (isAdmin) return AdminHomePage();
    if (isCashier) return CashierHomePage();
    if (isCustomer) return CustomerHomePage();

    return LoginPage();
  }
}
