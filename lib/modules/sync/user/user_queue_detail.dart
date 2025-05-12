import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/sync/user/user_queue_controller.dart';

class UserQueueDetailPage extends StatelessWidget {
  final UserQueueController controller = Get.find();

  UserQueueDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final queueItems = controller.repo.local.getQueuedItems();

    return Scaffold(
      appBar: AppBar(title: Text('List Queue User')),
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
                          for (var item in queueItems) {
                            await controller.rePostItem(item);
                            // controller.retrySync(item);
                          }
                          Get.snackbar(
                            'Sinkronisasi',
                            'Semua data disinkronkan',
                          );
                        },
                        icon: Icon(Icons.sync),
                        label: Text('Sync Semua'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: queueItems.length,
                      itemBuilder: (_, i) {
                        final item = queueItems[i];
                        final itemJson = item.toJson();
                        final previewText = itemJson.toString();

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: ListTile(
                            title: Text(
                              previewText,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Wrap(
                              spacing: 8,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.sync),
                                  tooltip: 'Sync Ulang',
                                  onPressed: () {
                                    // controller.retrySync(item);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.copy),
                                  tooltip: 'Copy JSON',
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(text: previewText),
                                    );
                                    Get.snackbar(
                                      'Disalin',
                                      'Data berhasil disalin',
                                    );
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
