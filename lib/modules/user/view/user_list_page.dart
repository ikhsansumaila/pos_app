import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/user/controller/user_controller.dart';
import 'package:pos_app/modules/user/view/user_detail_page.dart';
import 'package:pos_app/routes/routes.dart';

class UserListPage extends StatelessWidget {
  final controller = Get.find<UserController>();

  UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Get.toNamed(AppRoutes.userCreate.url),
      ),
      appBar: MyAppBar(title: 'Daftar User'),
      body: Obx(() {
        final users = controller.users;
        if (users.isEmpty) {
          return Center(child: Text('Tidak ada user'));
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (_, index) {
            final user = users[index];
            return ListTile(
              leading: CircleAvatar(child: Text(user.nama[0])),
              title: Text(user.nama),
              subtitle: Text(user.email),
              trailing: Text(user.role),
              onTap: () {
                Get.to(() => UserDetailPage(user: user));
                // Navigasi ke detail atau edit jika perlu
              },
            );
          },
        );
      }),
    );
  }
}
