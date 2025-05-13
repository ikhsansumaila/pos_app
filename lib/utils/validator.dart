import 'package:get/get.dart';

class AppValidator {
  static String? emailValidator(String? value) {
    if (value == null) {
      return 'Email wajib diisi';
    }
    if (!GetUtils.isEmail(value)) return 'Email tidak valid';
    return null;
  }
}
