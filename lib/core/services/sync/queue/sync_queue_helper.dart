import 'dart:developer';

import 'package:hive/hive.dart';

class SyncQueueDataHelper<T> {
  final Box box;
  final String key;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;

  SyncQueueDataHelper({required this.box, required this.key, required this.fromJson, required this.toJson});

  List<T> getQueuedItems() {
    log('get queued items for $key');
    final data = box.get(key, defaultValue: []);
    final result = (data as List).map((e) => fromJson(Map<String, dynamic>.from(e))).toList();
    return result;
  }

  void addToQueue(T item) {
    log('queue item to $key');
    final queue = box.get(key, defaultValue: []) as List;
    queue.add(toJson(item));
    box.put(key, queue);
  }

  Future<void> deleteQueueAt(int index) async {
    log('deleting item $index on queue for $key');
    await box.deleteAt(index);
  }

  Future<void> clearAllQueue() async {
    log('clearing all items on queue for $key');
    await box.put(key, []);
  }
}
