import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/sync/user/user_sync_controller.dart';

class UserSyncDetailPage extends StatelessWidget {
  final UserSyncController controller = Get.find();

  UserSyncDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'List Data User'),
      body: Obx(() {
        final localItems = controller.getUsers();
        if (localItems.isEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(), // agar bisa di-pull walau isinya kosong
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Get.dialog(
                        Center(child: CircularProgressIndicator()),
                        barrierDismissible: false,
                      );
                      await controller.startSync();
                      Get.back();
                    },
                    icon: Icon(Icons.sync),
                    label: Text('Update dari server'),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height, // agar tetap memenuhi layar
                child: Center(child: Text('Tidak ada data')),
              ),
            ],
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Get.dialog(
                      Center(child: CircularProgressIndicator()),
                      barrierDismissible: false,
                    );
                    await controller.startSync();
                    Get.back();
                  },
                  icon: Icon(Icons.sync),
                  label: Text('Update dari server'),
                ),
              ),
            ),
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
                      title: Text(item.nama ?? '-'),
                      subtitle: Text(item.email ?? '-'),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          Text(item.roleName ?? '-'),
                          // IconButton(
                          //   icon: Icon(Icons.sync),
                          //   tooltip: 'Sync Ulang',
                          //   onPressed: () async {
                          //     // await controller.rePostItem(item, index);
                          //   },
                          // ),
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
}
