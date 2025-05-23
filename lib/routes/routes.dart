// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';
import 'package:pos_app/modules/auth/login_page.dart';
import 'package:pos_app/modules/cart/view/cart_detail_page.dart';
import 'package:pos_app/modules/cart/view/cart_page.dart';
import 'package:pos_app/modules/home/cashier/cashier_home_page.dart';
import 'package:pos_app/modules/home/customer/customer_binding.dart';
import 'package:pos_app/modules/home/customer/customer_home_page.dart';
import 'package:pos_app/modules/home/home.dart';
import 'package:pos_app/modules/home/owner/owner_home_page.dart';
import 'package:pos_app/modules/home/splash_page.dart';
import 'package:pos_app/modules/product/view/product_add_page.dart';
import 'package:pos_app/modules/product/view/product_list_page.dart';
import 'package:pos_app/modules/stock/stock_mutation_page.dart';
import 'package:pos_app/modules/store/view/store_list_page.dart';
import 'package:pos_app/modules/sync/sync_binding.dart';
import 'package:pos_app/modules/sync/sync_page.dart';
import 'package:pos_app/modules/transaction/order/view/order_page.dart';
import 'package:pos_app/modules/transaction/purchase/view/purchase_list_page.dart';
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

class MyRoutes {
  // auth
  final AppRoute login;

  // home screen
  final AppRoute splash;
  final AppRoute home;
  final AppRoute cashierHome;
  final AppRoute customerHome;
  final AppRoute ownerDashboard;

  // user
  final AppRoute users;
  final AppRoute userCreate;

  // store
  final AppRoute store;

  // product
  final AppRoute products;
  final AppRoute addProduct;
  final AppRoute stockMutation;

  // transaction
  final AppRoute transactionSell;
  final AppRoute transactionPurchase;
  final AppRoute checkout;

  // order
  final AppRoute orders;

  // cart
  final AppRoute cart;
  final AppRoute cartDetail;

  // sync
  final AppRoute syncPage;

  /// Private constructor: semua harus diisi
  const MyRoutes._({
    required this.login,
    required this.splash,
    required this.home,
    required this.cashierHome,
    required this.customerHome,
    required this.ownerDashboard,
    required this.users,
    required this.userCreate,
    required this.store,
    required this.products,
    required this.addProduct,
    required this.stockMutation,
    required this.transactionPurchase,
    required this.transactionSell,
    required this.checkout,
    required this.orders,
    required this.cart,
    required this.cartDetail,
    required this.syncPage,
  });

  /// Factory singleton-style yang mengisi semua route
  static final MyRoutes instance = MyRoutes._(
    login: AppRoute.generate(url: '/login', page: () => LoginPage()),
    splash: AppRoute.generate(url: '/splash', page: () => SplashPage()),
    home: AppRoute.generate(url: '/home', page: () => Home()),
    cashierHome: AppRoute.generate(url: '/home/cashier', page: () => CashierHomePage()),
    customerHome: AppRoute.generate(
      url: '/home/customer',
      page: () => CustomerHomePage(),
      binding: CustomerHomeBinding(),
    ),
    ownerDashboard: AppRoute.generate(url: '/home/owner', page: () => OwnerHomePage()),
    users: AppRoute.generate(url: '/user', page: () => UserListPage()),
    userCreate: AppRoute.generate(url: '/user/create', page: () => CreateUserPage()),
    store: AppRoute.generate(url: '/store', page: () => StoreListPage()),
    products: AppRoute.generate(url: '/products', page: () => ProductPage()),
    addProduct: AppRoute.generate(url: '/products/add', page: () => AddProductPage()),
    stockMutation: AppRoute.generate(
      url: '/products/stock/mutation',
      page: () => StockMutationPage(),
    ),
    transactionPurchase: AppRoute.generate(
      url: '/transactions/purchase',
      page: () => PurchaseListPage(),
    ),
    transactionSell: AppRoute.generate(
      url: '/transactions/sell',
      page: () => TransactionSellingPage(),
    ),
    checkout: AppRoute.generate(url: '/transactions/sell/checkout', page: () => CheckoutPage()),
    orders: AppRoute.generate(url: '/orders', page: () => OrdersPage()),
    cart: AppRoute.generate(url: '/cart', page: () => CartPage()),
    cartDetail: AppRoute.generate(url: '/cart/detail', page: () => CartDetailPage()),
    syncPage: AppRoute.generate(url: '/sync', page: () => SyncPage(), binding: SyncBinding()),
  );

  /// Semua routes sebagai list
  List<GetPage> get routes => [
    login.page,
    splash.page,
    home.page,
    cashierHome.page,
    customerHome.page,
    ownerDashboard.page,
    users.page,
    userCreate.page,
    store.page,
    products.page,
    addProduct.page,
    stockMutation.page,
    transactionPurchase.page,
    transactionSell.page,
    checkout.page,
    orders.page,
    cart.page,
    cartDetail.page,
    syncPage.page,
  ];
}

final AppRoutes = MyRoutes.instance;
