import 'package:flutter/material.dart';
import 'package:pos_app/routes.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final String route;

  MenuItem({required this.title, required this.icon, required this.route});
}

final List<MenuItem> menuItems = [
  MenuItem(
    title: 'Buat Transaksi',
    icon: Icons.monetization_on,
    route: AppRoutes.transactions,
  ),
  MenuItem(
    title: 'Atur Barang',
    icon: Icons.list_alt,
    route: AppRoutes.products,
  ),
  // MenuItem(
  //   title: 'Keranjang',
  //   icon: Icons.shopping_cart,
  //   route: AppRoutes.cart,
  // ),
];
