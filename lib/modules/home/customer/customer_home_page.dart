import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/auth/auth_controller.dart';
import 'package:pos_app/modules/cart/view/cart_page.dart';
import 'package:pos_app/modules/common/widgets/app_dialog.dart';
import 'package:pos_app/modules/home/customer/customer_listing_product_widget.dart';
import 'package:pos_app/utils/constants/colors.dart';
// Import halaman lain kalau ada
// import 'package:pos_app/modules/transaction/view.dart';
// import 'package:pos_app/modules/report/view.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    CustomerListing(),
    CartPage(), // Ganti dengan halaman sebenarnya
    Center(child: Text("Settings")), // Ganti dengan halaman sebenarnya
  ];

  void _onNavTapped(int index) {
    if (index == 2) {
      _showSettingMenu();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showSettingMenu() {
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
                minHeight: MediaQuery.of(context).size.height * 0.1 + 20, // tinggi dinamis + 30
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text("Logout"),
                    onTap: () async {
                      bool confirmResult = await AppDialog.showConfirmationDialog(
                        context,
                        "Logout",
                        const Text('Anda yakin ingin Logout?'),
                      );
                      if (confirmResult) {
                        Get.find<AuthController>().logout();
                        Get.back();
                      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // biar transparan dan ikut body child
      body: SafeArea(child: IndexedStack(index: _selectedIndex, children: _pages)),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primary, // warna aktif
        unselectedItemColor: Colors.grey, // warna tidak aktif
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Keranjang'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
    );
  }
}
