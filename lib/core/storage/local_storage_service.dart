import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';

abstract class SyncableRemoteData<T> {
  dynamic get modelId;
  bool isDifferent(T other);
}

abstract class SyncableHiveObject<T> extends HiveObject implements SyncableRemoteData<T> {}

class LocalStorageService {
  static Future<void> updateFromRemote<T extends SyncableHiveObject<T>>({
    // required String boxName,
    required Box box,
    required List<T> apiData,
  }) async {
    int added = 0, updated = 0, deleted = 0;

    // final box = await Hive.openBox(boxName);
    log("box.values length : ${box.values.length}");

    // Set local map
    final Map<dynamic, T> localMap = {for (var item in box.values) item.modelId: item};

    // set api map
    // final Map<dynamic, T> apiMap = {for (var item in apiData) item.modelId: item};

    // Add or update
    for (final item in apiData) {
      final localItem = localMap[item.modelId];
      if (localItem == null) {
        await box.add(item); // add

        log("1. update from remote, localItem : ${jsonEncode(localItem)}");
        log("1. update from remote, apiData : ${jsonEncode(item)}");
        added++;
      } else if (item.isDifferent(localItem)) {
        await box.put(item.modelId, item); // update

        log("2. update from remote, localItem : ${jsonEncode(localItem)}");
        log("2. update from remote, apiData : ${jsonEncode(item)}");
        updated++;
      }
    }

    // Delete local if not exist in api
    // for (final localId in localMap.keys) {
    //   if (!apiMap.containsKey(localId)) {
    //     await box.delete(localId);
    //     log("3. update from remote, localId : $localId");
    //     log("3. update from remote, apiMap : $apiMap");
    //     deleted++;
    //   }
    // }
    if (added > 0 || updated > 0 || deleted > 0) {
      log("done updating $T from ${apiData.length} data remote, to ${localMap.length} data local");
    } else {
      log("nothing $T local data to update, (received ${apiData.length} remote data)");
    }

    log("added $added, updated $updated, deleted $deleted");
  }
}
