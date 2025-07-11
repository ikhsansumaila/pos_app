// sync_log_service.dart
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pos_app/modules/sync/sync_log/sync_log_model.dart';

class SyncLogService {
  final Box logBox;

  SyncLogService({required this.logBox});

  void addLog(SyncLog log) {
    final logs = getAllLogs();
    logs.add(log);
    logBox.put('logs', logs.map((e) => e.toJson()).toList());
  }

  List<SyncLog> getAllLogs() {
    final raw = logBox.get('logs', defaultValue: []) as List;
    return raw.map((e) => SyncLog.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<String> exportLogsAsTxt() async {
    final logs = getAllLogs();
    final buffer = StringBuffer();
    for (var log in logs) {
      String syncStatus = "BERHASIL";
      if (log.status == SyncLog.SYNC_STATUS_FAILED) {
        syncStatus = "GAGAL";
      } else if (log.status == SyncLog.SYNC_STATUS_WARNING) {
        syncStatus = "PERINGATAN";
      }

      buffer.writeln(
        "[${log.timestamp}] ${log.entity.toUpperCase()} | $syncStatus : ${log.message}",
      );
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/sync_log.txt');
    await file.writeAsString(buffer.toString());
    return file.path;
  }
}
