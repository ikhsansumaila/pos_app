// pages/purchase_list_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/transaction/purchase/controller/purchase_controller.dart';
import 'package:pos_app/modules/transaction/purchase/view/purchase_form_page.dart';

class PurchaseListPage extends StatelessWidget {
  final controller = Get.put(PurchaseController());

  PurchaseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Daftar Pembelian'),
      body: Obx(() {
        if (controller.purchaseList.isEmpty) {
          return Center(child: Text('Belum ada pembelian'));
        }
        return ListView.builder(
          itemCount: controller.purchaseList.length,
          itemBuilder: (context, index) {
            final purchase = controller.purchaseList[index];
            return ListTile(
              title: Text(purchase.description),
              subtitle: Text('Total: ${purchase.transTotal.toStringAsFixed(2)}'),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => PurchaseFormPage()),
        child: Icon(Icons.add),
      ),
    );
  }
}
