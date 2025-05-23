import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/common/scrollable_page.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/store/controller/store_controller.dart';

class StoreAddPage extends StatelessWidget {
  final controller = Get.find<StoreController>();

  StoreAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      bodyColor: Colors.white,
      appBar: MyAppBar(title: "Buat Toko Baru"),
      mainWidget: Form(
        key: controller.formKey,
        child:
        // Obx(
        //   () =>
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.nameController,
                decoration: InputDecoration(labelText: 'Nama Toko'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value!.isEmpty ? 'Nama Toko wajib diisi' : null,
                onChanged: (_) => controller.validateForm(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.addressController,
                decoration: InputDecoration(labelText: 'Alamat Toko'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value!.isEmpty ? 'Alamat Toko wajib diisi' : null,
                onChanged: (_) => controller.validateForm(),
              ),
            ],
          ),
          // ),
        ),
      ),
      fixedBottomWidget: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return ElevatedButton(
            onPressed: controller.isFormValid.value ? controller.createStore : null,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            ),
            child: Text('Simpan'),
          );
        }),
      ),
    );
  }
}
