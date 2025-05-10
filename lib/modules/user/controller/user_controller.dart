import 'package:get/get.dart';

class UserController extends GetxController {
  void createUser(Map<String, dynamic> data) {
    // Misalnya kirim ke backend
    print('Membuat user: $data');
    // Tambahkan logika API call di sini, atau simpan lokal/offline
    Get.snackbar('Sukses', 'User berhasil dibuat');
  }
}
