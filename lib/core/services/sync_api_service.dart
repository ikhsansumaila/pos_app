import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';

abstract class SyncableRemoteData<T> {
  dynamic get modelId;
  bool isDifferent(T other);
}

abstract class SyncableHiveObject<T> extends HiveObject
    implements SyncableRemoteData<T> {}

class SyncApiService {
  static Future<void> syncHiveBox<T extends SyncableHiveObject<T>>({
    required String boxName,
    required List<T> apiData,
  }) async {
    final box = await Hive.openBox<T>(boxName);
    final Map<dynamic, T> localMap = {
      for (var item in box.values) item.modelId: item,
    };
    final Map<dynamic, T> apiMap = {
      for (var item in apiData) item.modelId: item,
    };

    for (final item in apiData) {
      final localItem = localMap[item.modelId];
      if (localItem == null || item.isDifferent(localItem)) {
        await box.put(item.modelId, item); // ⬅️ add or update
      }
    }

    for (final localId in localMap.keys) {
      if (!apiMap.containsKey(localId)) {
        await box.delete(localId);
      }
    }
  }
}
