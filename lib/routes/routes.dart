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
import 'package:pos_app/modules/sync/sync_binding.dart';
import 'package:pos_app/modules/sync/sync_page.dart';
import 'package:pos_app/modules/transaction/order/view/order_page.dart';
import 'package:pos_app/modules/transaction/selling/view/checkout_page.dart';
import 'package:pos_app/modules/transaction/selling/view/transaction_page.dart';
import 'package:pos_app/modules/user/view/user_create_page.dart';
import 'package:pos_app/modules/user/view/user_list_page.dart';

class AppRoute {
  final String url;
  final GetPage page;

  AppRoute({required this.url, required this.page});

  static AppRoute generate({required String url, required GetPageBuilder page, Bindings? binding}) {
    return AppRoute(url: url, page: GetPage(name: url, page: page, binding: binding));
  }
}

class AppRoutes {
  // auth
  static final login = AppRoute.generate(url: '/login', page: () => LoginPage());

  // home screen
  static final splash = AppRoute.generate(url: '/splash', page: () => SplashPage());
  static final home = AppRoute.generate(url: '/home', page: () => Home());
  static final cashierHome = AppRoute.generate(url: '/home/cashier', page: () => CashierHomePage());
  static final customerHome = AppRoute.generate(
    url: '/home/customer',
    page: () => CustomerHomePage(),
    binding: CustomerHomeBinding(),
  );

  // user
  static final users = AppRoute.generate(url: '/user', page: () => UserListPage());
  static final userCreate = AppRoute.generate(url: '/user/create', page: () => CreateUserPage());

  // product
  static final products = AppRoute.generate(url: '/products', page: () => ProductPage());
  static final addProduct = AppRoute.generate(url: '/products/add', page: () => AddProductPage());
  static final stockMutation = AppRoute.generate(
    url: '/products/stock/mutation',
    page: () => StockMutationPage(),
  );

  // transaction
  static final transactionSell = AppRoute.generate(
    url: '/transactions/sell',
    page: () => TransactionSellingPage(),
  );
  static final checkout = AppRoute.generate(
    url: '/transactions/sell/checkout',
    page: () => CheckoutPage(),
  );

  // order
  static final orders = AppRoute.generate(url: '/orders', page: () => OrdersPage());

  // cart
  static final cart = AppRoute.generate(url: '/cart', page: () => CartPage());
  static final cartDetail = AppRoute.generate(url: '/cart/detail', page: () => CartDetailPage());

  // sync
  static final syncPage = AppRoute.generate(
    url: '/sync',
    page: () => SyncPage(),
    binding: SyncBinding(),
  );

  static final routes = [
    splash.page,
    login.page,
    home.page,
    cashierHome.page,
    customerHome.page,
    users.page,
    userCreate.page,
    products.page,
    addProduct.page,
    stockMutation.page,
    transactionSell.page,
    checkout.page,
    orders.page,
    cart.page,
    cartDetail.page,
    syncPage.page,
  ];
}
