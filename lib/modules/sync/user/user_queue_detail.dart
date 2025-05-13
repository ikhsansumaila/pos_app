import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/sync/user/user_queue_controller.dart';

class UserQueueDetailPage extends StatelessWidget {
  final UserQueueController controller = Get.find();

  UserQueueDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final queueItems = controller.getQueuedItems();

    return Scaffold(
      appBar: MyAppBar(title: 'List Data User'),
      body:
          queueItems.isEmpty
              ? Center(child: Text('Kosong'))
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await controller.rePostAllItems(queueItems);
                        },
                        icon: Icon(Icons.sync),
                        label: Text('Sinkronisasi Semua'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: queueItems.length,
                      itemBuilder: (_, index) {
                        final item = queueItems[index];
                        final previewText = jsonEncode(item);

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: ListTile(
                            title: Text(previewText, maxLines: 2, overflow: TextOverflow.ellipsis),
                            trailing: Wrap(
                              spacing: 8,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.sync),
                                  tooltip: 'Sync Ulang',
                                  onPressed: () async {
                                    await controller.rePostItem(item, index);
                                  },
                                ),
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
              ),
    );
  }
}
