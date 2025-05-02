import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/routes.dart';

class HomePage extends StatelessWidget {
  final List<_MenuItem> menuItems = [
    _MenuItem(
      title: 'Transaksi',
      icon: Icons.add_circle,
      route: AppRoutes.transactions,
    ),
    _MenuItem(
      title: 'Produk',
      icon: Icons.list_alt,
      route: AppRoutes.products,
    ),
    _MenuItem(title: 'Keranjang', icon: Icons.shopping_cart, route: AppRoutes.cart),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('POS Home'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.blue.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
          child: GridView.builder(
            itemCount: menuItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,  // Change this to 3 to display more items per row
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 2,
            ),
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return GestureDetector(
                onTap: () => Get.toNamed(item.route),
                child: _buildMenuItemCard(item),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItemCard(_MenuItem item) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade100, Colors.blue.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon, size: 48, color: Colors.white),
          SizedBox(height: 12),
          Text(
            item.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final String route;

  _MenuItem({required this.title, required this.icon, required this.route});
}
