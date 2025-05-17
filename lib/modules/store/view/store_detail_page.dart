import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/store/controller/store_controller.dart';
import 'package:pos_app/modules/store/data/models/store_model.dart';

class StoreDetailPage extends StatelessWidget {
  final controller = Get.find<StoreController>();
  final StoreModel store;

  StoreDetailPage({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Toko")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama Toko: ${store.storeName}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("ALamat: ${store.storeAddress}", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
