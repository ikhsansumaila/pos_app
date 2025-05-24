import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/common/scrollable_page.dart';
import 'package:pos_app/modules/common/widgets/fix_bottom_button.dart';
import 'package:pos_app/modules/user/view/user_update_page.dart';

import '../data/models/user_model.dart';

class UserDetailPage extends StatelessWidget {
  final UserModel user;

  const UserDetailPage({super.key, required this.user});

  Widget buildInfoTile(String title, String value) {
    return ListTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      bodyColor: Colors.white,
      appBar: AppBar(title: Text('Detail User')),
      mainWidget: Column(
        children: [
          buildInfoTile('User ID', user.id.toString()),
          buildInfoTile('Nama', user.nama ?? '-'),
          buildInfoTile('Email', user.email ?? '-'),
          buildInfoTile('Role', user.role ?? '-'),
          buildInfoTile('Status', user.status == 1 ? 'Aktif' : 'Nonaktif'),
          buildInfoTile('ID Toko', user.storeId.toString()),
          buildInfoTile('Nama Toko', user.storeName ?? '-'),
          buildInfoTile('Tanggal Dibuat', user.createdAt ?? '-'),
        ],
      ),
      fixedBottomWidget: FixedBottomButton(
        text: 'Ubah',
        onPressed: () => Get.to(() => UpdateUserPage(user: user)),
      ),
    );
  }
}
