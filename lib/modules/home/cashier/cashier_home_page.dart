import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/auth/login_controller.dart';
import 'package:pos_app/modules/common/app_bar.dart';
import 'package:pos_app/modules/common/widgets/confirmation_dialog.dart';
import 'package:pos_app/routes.dart';
import 'package:pos_app/utils/responsive_helper.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final String route;

  MenuItem({required this.title, required this.icon, required this.route});
}

final List<MenuItem> _menuItems = [
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
  MenuItem(
    title: 'Pesanan',
    icon: Icons.receipt_long,
    route: AppRoutes.orders, // order from customer (online)
  ),
];

class CashierHomePage extends StatelessWidget {
  const CashierHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(MediaQuery.of(context).size);

    var padding =
        responsive.isTablet
            ? EdgeInsets.fromLTRB(40, 20, 40, 20)
            : EdgeInsets.all(20);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(
        title: 'Selamat Datang',
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _showSettingsMenu(),
          ),
        ],
      ),
      body: Padding(
        padding: padding,
        child: GridView.builder(
          itemCount: _menuItems.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: responsive.isTablet ? 20 : 10,
            mainAxisSpacing: responsive.isTablet ? 20 : 10,
            childAspectRatio: 2,
          ),
          itemBuilder: (context, index) {
            final item = _menuItems[index];
            return GestureDetector(
              onTap: () => Get.toNamed(item.route),
              child: _buildMenuItemCard(item, responsive),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuItemCard(MenuItem item, ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(responsive.isTablet ? 30 : 10),
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
          Icon(item.icon, size: responsive.fontSize(48), color: Colors.white),
          SizedBox(height: 12),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: responsive.fontSize(16), //
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsMenu() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: double.infinity, // full width
                minHeight:
                    MediaQuery.of(context).size.height * 0.1 +
                    30, // tinggi dinamis + 30
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text("Logout"),
                    onTap: () async {
                      bool confirmResult = await showConfirmationDialog(
                        context,
                        "Logout",
                        const Text('Anda yakin ingin Logout?'),
                      );
                      if (confirmResult) {
                        Get.find<AuthController>().logout();
                        Get.back();
                      }
                      // Get.back(); // tutup bottom sheet
                      // Get.snackbar("Logout", "Anda telah logout.");
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      isScrollControlled: true,
    );
  }
}
