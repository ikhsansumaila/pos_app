import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/user/controller/user_update_controller.dart';
import 'package:pos_app/modules/user/data/models/user_model.dart';
import 'package:pos_app/modules/user/view/search_store_widget.dart';
import 'package:pos_app/utils/validator.dart';

class UpdateUserPage extends StatefulWidget {
  final UserModel user;

  const UpdateUserPage({super.key, required this.user});

  @override
  State<UpdateUserPage> createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  final controller = Get.put(UserUpdateController(userRepo: Get.find(), storeRepo: Get.find()));

  @override
  void initState() {
    super.initState();
    controller.selectedUser = widget.user; // simpan dulu user, biar dipakai saat onReady

    // controller.setFormData(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Ubah Data User'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.formKey,
            child: ListView(
              children: [
                const SizedBox(height: 12),
                TextFormField(
                  controller: controller.nameController,
                  decoration: InputDecoration(labelText: 'Nama'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value!.isEmpty ? 'Nama wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: controller.emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => AppValidator.emailValidator(value),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: controller.selectedRole.value?.id,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items:
                      controller.userRoles
                          .map((e) => DropdownMenuItem(value: e.id, child: Text(e.role)))
                          .toList(),
                  onChanged: (val) {
                    var selectedRole = controller.userRoles.firstWhere((role) => role.id == val);
                    controller.selectedRole.value = selectedRole;
                    controller.validateForm();
                  },
                ),
                const SizedBox(height: 12),
                if (controller.selectedRole.value?.id == 3)
                  StoreSearchDropdown(
                    items: controller.storeList,
                    selectedItem: controller.selectedStore.value,
                    onChanged: (store) {
                      controller.selectedStore.value = store;
                      controller.validateForm();
                    },
                  ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: controller.selectedStatus.value,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Aktif')),
                    DropdownMenuItem(value: 0, child: Text('Nonaktif')),
                  ],
                  onChanged: (val) => controller.selectedStatus.value = val!,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: controller.isFormValid.value ? controller.createUser : null,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
