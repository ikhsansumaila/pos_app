import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/user/controller/user_controller.dart';

class CreateUserPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final RxInt roleId = 2.obs; // default: admin
  final RxInt status = 1.obs;

  CreateUserPage({super.key}); // aktif

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buat User Baru')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator:
                    (value) => value!.isEmpty ? 'Nama wajib diisi' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator:
                    (value) => value!.isEmpty ? 'Email wajib diisi' : null,
              ),
              Obx(
                () => DropdownButtonFormField<int>(
                  value: roleId.value,
                  decoration: InputDecoration(labelText: 'Role'),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('User')),
                    DropdownMenuItem(value: 2, child: Text('Admin')),
                  ],
                  onChanged: (val) => roleId.value = val!,
                ),
              ),
              Obx(
                () => DropdownButtonFormField<int>(
                  value: status.value,
                  decoration: InputDecoration(labelText: 'Status'),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Aktif')),
                    DropdownMenuItem(value: 0, child: Text('Nonaktif')),
                  ],
                  onChanged: (val) => status.value = val!,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Kirim ke controller untuk disimpan
                    Get.find<UserController>().createUser({
                      'nama': namaController.text,
                      'email': emailController.text,
                      'role_id': roleId.value,
                      'status': status.value,
                    });
                  }
                },
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
