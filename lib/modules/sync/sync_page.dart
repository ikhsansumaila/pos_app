import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/sync/sync_controller.dart';

class SyncPage extends StatelessWidget {
  final controller = Get.find<SyncController>();

  SyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Monitoring Sinkronisasi'),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.entities.length,
              itemBuilder: (_, i) {
                final entity = controller.entities[i];
                return ListTile(
                  title: Text(entity.title),
                  trailing: ElevatedButton(
                    child: const Text('Detail'),
                    onPressed: () {
                      Get.to(() => entity.detailPage);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Obx(
                  () => ElevatedButton.icon(
                    icon:
                        controller.syncing.value
                            ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : Icon(Icons.sync),
                    label: Text("Sinkronisasi Semua"),
                    onPressed:
                        controller.syncing.value ? null : controller.manualSync,
                  ),
                ),
                SizedBox(width: 10),
                Obx(
                  () => OutlinedButton.icon(
                    icon:
                        controller.exporting.value
                            ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : Icon(Icons.download),
                    label: Text("Export Log"),
                    onPressed:
                        controller.exporting.value
                            ? null
                            : controller.exportLogs,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.logs.isEmpty) {
                return Center(child: Text("Belum ada log sinkronisasi"));
              }
              return ListView.builder(
                itemCount: controller.logs.length,
                itemBuilder: (_, i) {
                  final log = controller.logs[i];
                  return ListTile(
                    leading: Icon(
                      log.success ? Icons.check_circle : Icons.error,
                      color: log.success ? Colors.green : Colors.red,
                    ),
                    title: Text(
                      "${log.type.toUpperCase()} | ${log.success ? 'Berhasil' : 'Gagal'}",
                    ),
                    subtitle: Text(log.message),
                    trailing: Text(
                      DateFormat('dd/MM HH:mm').format(log.timestamp),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
