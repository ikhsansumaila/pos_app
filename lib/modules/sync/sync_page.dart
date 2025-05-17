import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/sync/sync_controller.dart';
import 'package:pos_app/modules/sync/sync_log/sync_log_detail_page.dart';

class SyncPage extends StatelessWidget {
  final controller = Get.find<SyncController>();

  SyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Monitoring Sinkronisasi'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    icon:
                        controller.syncing.value
                            ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                            : Icon(Icons.sync),
                    label: Text("Sinkronisasi Semua"),
                    onPressed: controller.syncing.value ? null : controller.manualSync,
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    icon:
                        controller.exporting.value
                            ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : Icon(Icons.visibility),
                    label: Text("Lihat Log"),
                    onPressed: () => Get.to(() => SyncLogDetailPage()),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.entities.length,
              itemBuilder: (_, i) {
                final entity = controller.entities[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: ListTile(
                    title: Text(entity.title),
                    trailing: ElevatedButton(
                      child: const Text('List Data'),
                      onPressed: () {
                        Get.to(() => entity.detailPage)?.then((_) {
                          controller.refreshLogs();
                        });
                      },
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
