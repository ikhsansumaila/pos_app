import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';

abstract class SyncableRemoteData<T> {
  dynamic get modelId;
  bool isDifferent(T other);
}

abstract class SyncableHiveObject<T> extends HiveObject implements SyncableRemoteData<T> {}

class LocalStorageUpdateResult {
  int added;
  int updated;
  int deleted;
  List<String> failedDescriptions;

  LocalStorageUpdateResult({
    required this.added,
    required this.updated,
    required this.deleted,
    required this.failedDescriptions,
  });

  toJson() => {
    'added': added,
    'updated': updated,
    'deleted': deleted,
    'failedDescriptions': failedDescriptions.toString(),
  };
}

class LocalStorageService {
  static Future<LocalStorageUpdateResult> updateFromRemote<T extends SyncableHiveObject<T>>({
    required Box box,
    required List<T> apiData,
    bool deleteNotExist = false,
  }) async {
    int added = 0, updated = 0, deleted = 0;
    List<String> failedDescriptions = [];
    Map<dynamic, T> localMap = {};
    Map<dynamic, T> apiMap = {};

    try {
      // final box = await Hive.openBox(boxName);
      log("box.values length : ${box.values.length}");

      // Set local map
      localMap = {for (var item in box.values) item.modelId: item};

      // set api map
      apiMap = {for (var item in apiData) item.modelId: item};

      // Add or update
      for (final item in apiData) {
        try {
          final localItem = localMap[item.modelId];
          if (localItem == null) {
            await box.add(item); // add

            log("1. add from remote, localItem $T: ${jsonEncode(localItem)}");
            log("1. add from remote, apiData $T: ${jsonEncode(item)}");
            added++;
          } else if (item.isDifferent(localItem)) {
            await box.put(item.modelId, item); // update

            log("2. update from remote, localItem $T: ${jsonEncode(localItem)}");
            log("2. update from remote, apiData $T: ${jsonEncode(item)}");
            updated++;
          }
        } catch (err) {
          failedDescriptions.add('error on item $item : ${err.toString()}');
        }
      }

      // Delete local if not exist in api
      if (deleteNotExist) {
        for (final localId in localMap.keys) {
          if (!apiMap.containsKey(localId)) {
            await box.delete(localId);
            log("3. update from remote, localId : $localId");
            log("3. update from remote, apiMap : $apiMap");
            deleted++;
          }
        }
      }
    } catch (e) {
      failedDescriptions.add(e.toString());
    }

    if (added > 0 || updated > 0 || deleted > 0) {
      log("done updating $T from ${apiData.length} data remote, to ${localMap.length} data local");
    } else {
      log("nothing $T local data to update, (received ${apiData.length} remote data)");
    }
    log("added $added, updated $updated, deleted $deleted");

    log("failedDescriptions length: ${failedDescriptions.length}");
    // if (failedDescriptions.isNotEmpty) {
    //   for (final description in failedDescriptions) {
    //     log("failed: $description");
    //   }
    // }

    return LocalStorageUpdateResult(
      added: added,
      updated: updated,
      deleted: deleted,
      failedDescriptions: failedDescriptions,
    );
  }
}
