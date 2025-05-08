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
import 'package:pos_app/modules/transaction/order/view/order_page.dart';

class AppRoute {
  final String url;
  final GetPage page;

  AppRoute({required this.url, required this.page});
}

class AppRoutes {
  static final splash = AppRoute(
    url: '/splash',
    page: GetPage(name: '/splash', page: () => SplashPage()),
  );

  static final login = AppRoute(
    url: '/login',
    page: GetPage(name: '/login', page: () => LoginPage()),
  );

  static final home = AppRoute(
    url: '/home',
    page: GetPage(name: '/home', page: () => Home()),
  );

  static final cashierHome = AppRoute(
    url: '/home/cashier',
    page: GetPage(name: '/home/cashier', page: () => CashierHomePage()),
  );

  static final customerHome = AppRoute(
    url: '/home/customer',
    page: GetPage(
      name: '/home/customer',
      page: () => CustomerHomePage(),
      binding: CustomerHomeBinding(),
    ),
  );

  static final products = AppRoute(
    url: '/products',
    page: GetPage(name: '/products', page: () => ProductPage()),
  );

  static final addProduct = AppRoute(
    url: '/products/add',
    page: GetPage(name: '/products/add', page: () => AddProductPage()),
  );

  static final stockMutation = AppRoute(
    url: '/products/stock/mutation',
    page: GetPage(
      name: '/products/stock/mutation',
      page: () => StockMutationPage(),
    ),
  );

  static final transactions = AppRoute(
    url: '/transactions',
    page: GetPage(name: '/transactions', page: () => TransactionPage()),
  );

  static final checkout = AppRoute(
    url: '/checkout',
    page: GetPage(name: '/checkout', page: () => CheckoutPage()),
  );

  static final orders = AppRoute(
    url: '/orders',
    page: GetPage(name: '/orders', page: () => OrdersPage()),
  );

  static final cart = AppRoute(
    url: '/cart',
    page: GetPage(name: '/cart', page: () => CartPage()),
  );

  static final cartDetail = AppRoute(
    url: '/cart/detail',
    page: GetPage(name: '/cart/detail', page: () => CartDetailPage()),
  );

  static final routes = [
    splash.page,
    login.page,
    home.page,
    cashierHome.page,
    customerHome.page,
    products.page,
    addProduct.page,
    stockMutation.page,
    transactions.page,
    checkout.page,
    orders.page,
    cart.page,
    cartDetail.page,
  ];
}
