import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/sync/sync_controller.dart';
import 'package:pos_app/utils/constants/colors.dart';

class SyncLogDetailPage extends StatelessWidget {
  final controller = Get.find<SyncController>();

  SyncLogDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Log Detail'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                        controller.exporting.value || controller.logs.isEmpty
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
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: ListTile(
                      leading: Icon(
                        log.success ? Icons.check_circle : Icons.error,
                        color: log.success ? Colors.green : Colors.red,
                      ),
                      title: Text(
                        "${log.type.toUpperCase()} | ${log.success ? 'Berhasil' : 'Gagal'}",
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(log.message),
                          Text(DateFormat('dd/MM HH:mm').format(log.timestamp)),
                        ],
                      ),
                      trailing: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          RawMaterialButton(
                            onPressed: () async {
                              // await controller.rePostItem(item, index);
                              Get.dialog(
                                AlertDialog(
                                  title: Text('Detail Data'),
                                  content: SingleChildScrollView(
                                    child: Text(
                                      log.data, // tampilkan data
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  actions: [
                                    IconButton(
                                      icon: Icon(Icons.copy),
                                      tooltip: 'Copy JSON',
                                      onPressed: () {
                                        Clipboard.setData(
                                          ClipboardData(text: log.data),
                                        );
                                        Get.snackbar(
                                          'Disalin',
                                          'Data berhasil disalin',
                                        );
                                      },
                                    ),
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: Text('Tutup'),
                                    ),
                                  ],
                                ),
                                barrierDismissible:
                                    true, // klik luar untuk tutup
                              );
                            },
                            elevation: 2.0,
                            fillColor: AppColors.primary,
                            shape: CircleBorder(),
                            constraints: BoxConstraints.tightFor(
                              width: 40.0,
                              height: 40.0,
                            ),
                            child: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
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
