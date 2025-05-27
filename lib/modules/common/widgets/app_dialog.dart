import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialog {
  static Future<bool> showConfirmationDialog(
    BuildContext context,
    String title,
    Widget content,
    // List<Widget> actions,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(title),
                content: content,
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Tidak'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Ya'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  static Future<void> showErrorOffline() async {
    return await Get.dialog(
      AlertDialog(
        title: const Text('Tidak ada koneksi internet'),
        content: const Text('Harap periksa koneksi internet Anda'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  static Future<void> show(String title, {required String content}) async {
    return await Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  static Future<void> showCreateSuccess() async {
    return await Get.dialog(
      AlertDialog(
        title: const Text('Berhasil'),
        content: Text('Data berhasil disimpan'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  static Future<bool> showExitConfirmationDialog(BuildContext context) async {
    var result =
        await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Keluar Halaman'),
                content: const Text(
                  'Data akan terhapus, Anda yakin ingin meninggalkan halaman ini?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Tidak'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Ya'),
                  ),
                ],
              ),
        ) ??
        false;
    return result;
  }

  static Future<void> showLoading() async {
    return await Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }
}
