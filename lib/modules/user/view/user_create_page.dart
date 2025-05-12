import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/user/controller/user_form_controller.dart';
import 'package:pos_app/modules/user/view/search_store_widget.dart';

class CreateUserPage extends StatelessWidget {
  CreateUserPage({super.key});

  final controller = Get.put(UserFormController(userRepo: Get.find(), storeRepo: Get.find()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat User Baru')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Obx(
            () => ListView(
              children: [
                const SizedBox(height: 8),
                Text("Informasi User", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),

                _buildTextField(controller.namaController, 'Nama'),
                const SizedBox(height: 12),
                _buildTextField(controller.emailController, 'Email'),
                const SizedBox(height: 12),

                DropdownButtonFormField<int>(
                  value: controller.selectedRoleId.value,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items:
                      controller.userRoles
                          .map((e) => DropdownMenuItem(value: e.id, child: Text(e.role)))
                          .toList(),
                  onChanged: (val) => controller.selectedRoleId.value = val!,
                ),
                const SizedBox(height: 12),

                if (controller.selectedRoleId.value == 3) // 3 is kasir
                  StoreSearchDropdown(
                    items: controller.storeList,
                    selectedItem: controller.selectedStore.value,
                    onChanged: (store) => controller.selectedStore.value = store,
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
                  onPressed: controller.isFormValid ? controller.createUserIfValid : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController textController, String label) {
    return TextFormField(
      controller: textController,
      decoration: InputDecoration(labelText: label),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => value!.isEmpty ? '$label wajib diisi' : null,
    );
  }
}
