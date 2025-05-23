import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/auth/auth_controller.dart';
import 'package:pos_app/modules/auth/auth_model.dart';
import 'package:pos_app/modules/auth/login_page.dart';
import 'package:pos_app/modules/home/admin/admin_home_page.dart';
import 'package:pos_app/modules/home/cashier/cashier_home_page.dart';
import 'package:pos_app/modules/home/customer/customer_home_page.dart';
import 'package:pos_app/utils/constants/constant.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    UserLoginModel? loginData = authController.getUserLoginData();
    if (loginData == null) {
      return LoginPage();
    }

    String role = loginData.role.trim().toLowerCase();
    bool isSuperAdmin = role == AppUserRole.superAdmin;
    bool isAdmin = role == AppUserRole.admin;
    bool isOwner = role == AppUserRole.owner;
    bool isCashier = role == AppUserRole.cashier;
    bool isCustomer = role == AppUserRole.customer;

    if (isSuperAdmin || isAdmin || isOwner) return AdminHomePage();
    if (isCashier) return CashierHomePage();
    if (isCustomer) return CustomerHomePage();

    return LoginPage();
  }
}
