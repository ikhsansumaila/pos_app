import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/common/app_bar.dart';
import 'package:pos_app/modules/home/menu.dart';
import 'package:pos_app/utils/responsive_helper.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(MediaQuery.of(context).size);

    var padding =
        responsive.isTablet
            ? EdgeInsets.fromLTRB(40, 20, 40, 20)
            : EdgeInsets.all(20);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: 'Selamat Datang'),
      body: Padding(
        padding: padding,
        child: GridView.builder(
          itemCount: menuItems.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: responsive.isTablet ? 20 : 10,
            mainAxisSpacing: responsive.isTablet ? 20 : 10,
            childAspectRatio: 2,
          ),
          itemBuilder: (context, index) {
            final item = menuItems[index];
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
}
