import 'package:flutter/material.dart';
import 'package:pos_app/modules/dashboard/sales_dashboard_view.dart';
import 'package:pos_app/modules/home/admin/admin_home_page.dart';
import 'package:pos_app/utils/constants/colors.dart';

class OwnerHomePage extends StatefulWidget {
  const OwnerHomePage({super.key});

  @override
  State<OwnerHomePage> createState() => _OwnerHomePageState();
}

class _OwnerHomePageState extends State<OwnerHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    AdminHomePage(), // Ganti dengan halaman Home kamu
    SalesDashboardView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primary, // warna aktif
        unselectedItemColor: Colors.grey, // warna tidak aktif
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Laporan'),
        ],
      ),
    );
  }
}
