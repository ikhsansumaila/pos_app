import 'package:get/get.dart';
import 'package:pos_app/modules/auth/login_page.dart';
import 'package:pos_app/modules/cart/view/cart_page.dart';
import 'package:pos_app/modules/home/home.dart';
import 'package:pos_app/modules/product/view/product_add_page.dart';
import 'package:pos_app/modules/product/view/product_list_page.dart';
import 'package:pos_app/modules/product/view/stock_mutation_page.dart';
import 'package:pos_app/modules/transaction/checkout/checkout_page.dart';
import 'package:pos_app/modules/transaction/purchase_order/order_page.dart';
import 'package:pos_app/modules/transaction/select_item/view/transaction_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/';

  // product
  static const String products = '/products';
  static const String addProduct = '/products/add';
  static const String stockMutation = '/products/stock/mutation';

  // transaction
  static const String transactions = '/transactions';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String cart = '/cart';

  static final routes = [
    GetPage(name: login, page: () => LoginPage()),
    GetPage(name: home, page: () => HomePage()),

    // product
    GetPage(name: products, page: () => ProductPage()),
    GetPage(name: addProduct, page: () => AddProductPage()),
    GetPage(name: stockMutation, page: () => StockMutationPage()),

    //transaction
    GetPage(name: transactions, page: () => TransactionPage()),
    GetPage(name: checkout, page: () => CheckoutPage()),
    GetPage(name: orders, page: () => OrdersPage()),
    GetPage(name: cart, page: () => CartPage()),
  ];
}
