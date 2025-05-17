import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/store/controller/store_controller.dart';

class StoreAddPage extends StatelessWidget {
  final controller = Get.find<StoreController>();

  StoreAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Buat Toko Baru"),
      body: Form(
        key: controller.formKey,
        child: Obx(
          () => Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 12),
                TextFormField(
                  controller: controller.nameController,
                  decoration: InputDecoration(labelText: 'Nama Toko'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value!.isEmpty ? 'Nama Toko wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: controller.addressController,
                  decoration: InputDecoration(labelText: 'Alamat Toko'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value!.isEmpty ? 'Alamat Toko wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text("Simpan"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: controller.isFormValid ? controller.createStore : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
