import 'package:get/get.dart';
import 'package:pos_app/modules/auth/login_page.dart';
import 'package:pos_app/modules/cart/view/cart_detail_page.dart';
import 'package:pos_app/modules/cart/view/cart_page.dart';
import 'package:pos_app/modules/home/cashier/cashier_home_page.dart';
import 'package:pos_app/modules/home/customer/customer_binding.dart';
import 'package:pos_app/modules/home/customer/customer_home_page.dart';
import 'package:pos_app/modules/home/home.dart';
import 'package:pos_app/modules/home/splash_page.dart';
import 'package:pos_app/modules/product/view/product_add_page.dart';
import 'package:pos_app/modules/product/view/product_list_page.dart';
import 'package:pos_app/modules/stock/stock_mutation_page.dart';
import 'package:pos_app/modules/transaction/checkout/checkout_page.dart';
import 'package:pos_app/modules/transaction/main/view/transaction_page.dart';
import 'package:pos_app/modules/transaction/purchase_order/order_page.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';

  // home
  static const String home = '/home';
  static const String cashierHome = '/home/cashier';
  static const String customerHome = '/home/customer';

  // product
  static const String products = '/products';
  static const String addProduct = '/products/add';
  static const String stockMutation = '/products/stock/mutation';

  // transaction
  static const String transactions = '/transactions';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String cart = '/cart';
  static const String cartDetail = '/cart/detail';

  static final routes = [
    GetPage(name: splash, page: () => SplashPage()),
    GetPage(name: login, page: () => LoginPage()),

    // home
    GetPage(name: home, page: () => Home()),
    GetPage(name: cashierHome, page: () => CashierHomePage()),
    GetPage(
      name: customerHome,
      page: () => CustomerHomePage(),
      binding: CustomerHomeBinding(),
    ),

    // product
    GetPage(name: products, page: () => ProductPage()),
    GetPage(name: addProduct, page: () => AddProductPage()),
    GetPage(name: stockMutation, page: () => StockMutationPage()),

    //transaction
    GetPage(name: transactions, page: () => TransactionPage()),
    GetPage(name: checkout, page: () => CheckoutPage()),
    GetPage(name: orders, page: () => OrdersPage()),
    GetPage(name: cart, page: () => CartPage()),
    GetPage(name: cartDetail, page: () => CartDetailPage()),
  ];
}
