import 'package:shared_preferences/shared_preferences.dart';

// class SharedPrefs {
//   static final SharedPrefs _instance = SharedPrefs._internal();

//   factory SharedPrefs() => _instance;

//   SharedPrefs._internal();

//   SharedPreferences? _prefs;

//   Future<void> init() async {
//     _prefs ??= await SharedPreferences.getInstance();
//   }

//   SharedPreferences get prefs {
//     if (_prefs == null) {
//       throw Exception("SharedPrefs not initialized. Call init() first.");
//     }
//     return _prefs!;
//   }

//   // Optional utility methods
//   Future<void> setString(String key, String value) async =>
//       await prefs.setString(key, value);

//   String? getString(String key) => prefs.getString(key);

//   Future<void> setBool(String key, bool value) async =>
//       await prefs.setBool(key, value);

//   bool getBool(String key) => prefs.getBool(key) ?? false;

//   Future<void> remove(String key) async => await prefs.remove(key);

//   bool contains(String key) => prefs.containsKey(key);
// }


class MySharedPreferences {
  static SharedPreferences? _sharedPrefs;
  init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  bool getBool(String key) => _sharedPrefs!.getBool(key) ?? false;

  String getString(key) {
    String value = '';

    if (_sharedPrefs != null && _sharedPrefs!.getString(key) != null) {
      value = _sharedPrefs!.getString(key)!;
    }

    return value;
  }

  void setKey(String key, String value) {
    if (_sharedPrefs != null) {
      _sharedPrefs!.setString(key, value);
    }
  }

  void remove(String key) {
    if (_sharedPrefs != null) {
      _sharedPrefs!.remove(key);
    }
  }
}

final sharedPrefs = MySharedPreferences();