import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/sync/sync_product/product_sync_controller.dart';

class ProductSyncDetailPage extends StatelessWidget {
  final ProductSyncController controller = Get.find();
  final int storeId = 1;

  ProductSyncDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'List Data Product'),
      body: Obx(() {
        final localItems = controller.getProducts();
        if (localItems.isEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(), // agar bisa di-pull walau isinya kosong
            children: [
              _updateButton(),
              SizedBox(
                height: MediaQuery.of(context).size.height, // agar tetap memenuhi layar
                child: Center(child: Text('Tidak ada data')),
              ),
            ],
          );
        }

        return Column(
          children: [
            _updateButton(),
            Expanded(
              child: ListView.builder(
                itemCount: localItems.length,
                itemBuilder: (_, index) {
                  final item = localItems[index];
                  final previewText = jsonEncode(item);

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      // title: Text(previewText, maxLines: 2, overflow: TextOverflow.ellipsis),
                      leading: CircleAvatar(child: Text((item.nama ?? '-')[0])),
                      title: Text(item.namaBrg ?? '-'),
                      subtitle: Text(item.kodeBrg ?? '-'),
                      trailing: Wrap(
                        spacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text('Stok ${item.stok}'),
                          IconButton(
                            icon: Icon(Icons.copy),
                            tooltip: 'Copy JSON',
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: previewText));
                              Get.snackbar('Disalin', 'Data berhasil disalin');
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _updateButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ElevatedButton.icon(
          onPressed: () async {
            Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);
            await controller.startSync(storeId);
            Get.back();
          },
          icon: Icon(Icons.sync),
          label: Text('Update dari server'),
        ),
      ),
    );
  }
}
