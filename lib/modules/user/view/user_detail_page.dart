import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text('Detail User')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          buildInfoTile('User ID', user.id.toString()),
          buildInfoTile('Nama', user.nama),
          buildInfoTile('Email', user.email),
          buildInfoTile('Role', user.role),
          buildInfoTile('Status', user.status == 1 ? 'Aktif' : 'Nonaktif'),
          buildInfoTile('ID Toko', user.storeId.toString()),
          buildInfoTile('Nama Toko', user.storeName ?? '-'),
          buildInfoTile('Tanggal Dibuat', user.createdAt),
        ],
      ),
    );
  }
}
