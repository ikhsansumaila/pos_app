import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/auth/auth_controller.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/common/widgets/app_dialog.dart';
import 'package:pos_app/modules/home/menu.dart';
import 'package:pos_app/utils/responsive_helper.dart';

class AdminHomePage extends StatelessWidget {
  AdminHomePage({super.key});
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    final user = authController.getUserLoginData();
    if (user == null) {
      return const Center(child: Text("Anda tidak memiliki akses"));
    }

    final responsive = ResponsiveHelper(context);

    var padding = responsive.isTablet ? EdgeInsets.fromLTRB(40, 20, 40, 20) : EdgeInsets.all(20);
    var menu = authController.getUserMenu();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(
        title: 'Selamat Datang ${user.nama}',
        actions: [IconButton(icon: Icon(Icons.settings), onPressed: () => _showSettingsMenu())],
      ),
      body: Padding(
        padding: padding,
        child: GridView.builder(
          itemCount: menu.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: responsive.isTablet ? 20 : 10,
            mainAxisSpacing: responsive.isTablet ? 20 : 10,
            childAspectRatio: 2,
          ),
          itemBuilder: (context, index) {
            final item = menu[index];
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
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(4, 4))],
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
                minHeight: MediaQuery.of(context).size.height * 0.1 + 30, // tinggi dinamis + 30
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
}
