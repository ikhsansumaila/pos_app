import 'package:get/get.dart';
import 'package:pos_app/modules/auth/login_page.dart';
import 'package:pos_app/modules/cart/checkout_page.dart';
import 'package:pos_app/modules/cart/view/cart_page.dart';
import 'package:pos_app/modules/home/home.dart';
import 'package:pos_app/modules/product/view/product_page.dart';
import 'package:pos_app/modules/transaction/transaction.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/';
  static const String products = '/products';
  static const String transactions = '/transactions';
  static const String cart = '/cart';
  static const String checkout = '/checkout';

  static final routes = [
    GetPage(name: login, page: () => LoginPage()),
    GetPage(name: home, page: () => HomePage()),
    GetPage(name: cart, page: () => CartPage()),
    GetPage(name: products, page: () => ProductPage()),
    GetPage(name: transactions, page: () => TransactionPage()),
    GetPage(name: checkout, page: () => CheckoutPage()),
  ];
}
