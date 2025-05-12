import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void showSyncResultSnackbar({
    bool isSuccess = true,
    String message = '',
  }) {
    Get.snackbar(
      'Sinkronisasi ${isSuccess ? 'Berhasil' : 'Gagal'}',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isSuccess ? Colors.green.shade600 : Colors.red.shade600,
      colorText: Colors.white,
      icon: Icon(
        isSuccess ? Icons.check_circle : Icons.error,
        color: Colors.white,
      ),
      margin: EdgeInsets.all(12),
      borderRadius: 8,
      duration: Duration(seconds: 3),
    );
  }
}
