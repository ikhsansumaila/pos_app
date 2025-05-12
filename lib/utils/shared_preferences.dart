import 'package:shared_preferences/shared_preferences.dart';

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
