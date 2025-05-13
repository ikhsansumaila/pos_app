import 'package:hive/hive.dart';

class CacheHelper {
  static int generateNextCacheId(Box box) {
    final existingIds = box.keys.cast<int>().toList();
    if (existingIds.isEmpty) return 1;
    return existingIds.reduce((a, b) => a > b ? a : b) + 1;
  }
}
