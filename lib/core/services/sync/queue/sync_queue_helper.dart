import 'dart:developer';

import 'package:hive/hive.dart';

class SyncQueueDataHelper<T> {
  final Box box;
  final String key;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;

  SyncQueueDataHelper({
    required this.box,
    required this.key,
    required this.fromJson,
    required this.toJson,
  });

  List<T> getQueuedItems() {
    log('get queued items for $key');
    final data = box.get(key, defaultValue: []);
    return (data as List)
        .map((e) => fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  void addToQueue(T item) {
    log('queue item to $key');
    final queue = box.get(key, defaultValue: []) as List;
    queue.add(toJson(item));
    box.put(key, queue);
  }

  void clearQueue() {
    log('clear queue for $key');
    box.put(key, []);
  }
}
