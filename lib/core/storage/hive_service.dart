import 'package:hive/hive.dart';

class HiveService {
  final Map<String, Box> _boxCache = {};

  /// Ensure box is open before accessing
  Future<Box> _ensureBoxOpen(String name) async {
    if (_boxCache.containsKey(name) && _boxCache[name]!.isOpen) {
      return _boxCache[name]!;
    }

    if (Hive.isBoxOpen(name)) {
      _boxCache[name] = Hive.box(name);
      return _boxCache[name]!;
    }

    final openedBox = await Hive.openBox(name);
    _boxCache[name] = openedBox;
    return openedBox;
  }

  /// Get a value from a box
  Future<T?> get<T>(String boxName, dynamic key) async {
    final box = await _ensureBoxOpen(boxName);
    return box.get(key);
  }

  /// Put a value into a box
  Future<void> put<T>(String boxName, dynamic key, T value) async {
    final box = await _ensureBoxOpen(boxName);
    await box.put(key, value);
  }

  /// Delete a value
  Future<void> delete(String boxName, dynamic key) async {
    final box = await _ensureBoxOpen(boxName);
    await box.delete(key);
  }

  /// Get all values as List
  Future<List> getAllValues(String boxName) async {
    final box = await _ensureBoxOpen(boxName);
    return box.values.toList();
  }

  /// Get full Map of box
  Future<Map<dynamic, dynamic>> getAll(String boxName) async {
    final box = await _ensureBoxOpen(boxName);
    return box.toMap();
  }

  /// Clear box
  Future<void> clear(String boxName) async {
    final box = await _ensureBoxOpen(boxName);
    await box.clear();
  }

  /// Optional: Close a specific box (e.g. on logout)
  Future<void> closeBox(String boxName) async {
    if (_boxCache.containsKey(boxName)) {
      await _boxCache[boxName]!.close();
      _boxCache.remove(boxName);
    }
  }

  /// Optional: Close all boxes
  Future<void> closeAllBoxes() async {
    for (final box in _boxCache.values) {
      if (box.isOpen) await box.close();
    }
    _boxCache.clear();
  }
}
