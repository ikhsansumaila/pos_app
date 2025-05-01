import 'package:get/get.dart';
import 'package:pos_app/modules/cart/checkout_page.dart';
import 'package:pos_app/modules/cart/view/cart_page.dart';
import 'package:pos_app/modules/home/home.dart';
import 'package:pos_app/modules/product/view/product_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String products = '/products';
  static const String cart = '/cart';
  static const String checkout = '/checkout';

  static final routes = [
    GetPage(name: home, page: () => HomePage()),
    GetPage(name: cart, page: () => CartPage()),
    GetPage(name: products, page: () => ProductPage()),
    GetPage(name: checkout, page: () => CheckoutPage()),
  ];
}
