import 'package:flutter/material.dart';
import 'package:pos_app/routes/routes.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final String route;

  MenuItem({required this.title, required this.icon, required this.route});
}

final Map<String, MenuItem> allMenu = {
  'transaction': MenuItem(
    title: 'Buat Transaksi',
    icon: Icons.point_of_sale,
    route: AppRoutes.transactionSell.url,
  ),
  'product': MenuItem(title: 'Atur Barang', icon: Icons.list_alt, route: AppRoutes.products.url),
  'order': MenuItem(
    title: 'Pesanan',
    icon: Icons.receipt_long,
    route: AppRoutes.orders.url, // order from customer (online)
  ),
  'store': MenuItem(title: 'Atur Toko', icon: Icons.store, route: AppRoutes.store.url),
  'user': MenuItem(title: 'Akun Pengguna', icon: Icons.person, route: AppRoutes.users.url),
  'sync': MenuItem(title: 'Sinkronisasi Data', icon: Icons.sync, route: AppRoutes.syncPage.url),
};

class HomeMenu {
  static List<MenuItem> getMenuItem(String role) {
    List<MenuItem> menuItems = [];

    switch (role) {
      case 'admin':
        menuItems = [
          allMenu['transaction']!,
          allMenu['product']!,
          // allMenu['order']!,
          allMenu['store']!,
          allMenu['user']!,
          allMenu['sync']!,
        ];
      case 'cashier':
        menuItems = [
          allMenu['transaction']!,
          allMenu['product']!,
          allMenu['order']!,
          allMenu['sync']!,
        ];
    }
    return menuItems;
  }
}
