import 'package:get/get.dart';
import 'package:pos_app/modules/sync/sync_log/sync_log_service.dart';
import 'package:pos_app/modules/user/data/source/user_local.dart';
import 'package:pos_app/modules/user/data/source/user_remote.dart';

class UserQueueController extends GetxController {
  final UserLocalDataSource local;
  final UserRemoteDataSource remote;
  final SyncLogService logService;

  UserQueueController({required this.local, required this.remote, required this.logService});

  // List<UserCreateModel> getQueuedItems() {
  //   return local.getQueuedItems();
  // }

  // Future<void> rePostAllItems(List<UserCreateModel> items) async {
  // int totalFailed = 0;
  // int totalSuccess = 0;

  // Get.dialog(
  //   Center(child: CircularProgressIndicator()),
  //   barrierDismissible: false,
  // );

  // // for (var item in items) {
  // for (int i = 0; i < items.length; i++) {
  //   var item = items[i];
  //   var response = await remote.postUser(item);
  //   bool isSuccess = response.statusCode == 200 || response.statusCode == 201;

  //   if (isSuccess) {
  //     await local.deleteQueueAt(i); // Hapus data yg sukses
  //     totalSuccess++;
  //   } else {
  //     totalFailed++;
  //   }

  //   // write to log
  //   logService.addLog(
  //     SyncLog(
  //       type: 'user',
  //       success: isSuccess,
  //       message: isSuccess ? 'Users synced' : 'Failed syncing users',
  //       data: response.data,
  //       timestamp: DateTime.now(),
  //     ),
  //   );
  // }

  // Get.back();
  // Get.snackbar(
  //   'Sinkronisasi Selesai',
  //   'Berhasil sinkronisasi $totalSuccess data, gagal sinkronisasi $totalFailed data',
  //   snackPosition: SnackPosition.BOTTOM,
  // );
}

// Future<void> rePostItem(UserCreateModel item, int queueIndex) async {
// Get.dialog(
//   Center(child: CircularProgressIndicator()),
//   barrierDismissible: false,
// );

// var response = await remote.postUser(item);
// bool isSuccess = response.statusCode == 200 || response.statusCode == 201;
// if (isSuccess) {
//   await local.deleteQueueAt(queueIndex); // Hapus data yg sukses
// }

// // write to log
// logService.addLog(
//   SyncLog(
//     type: 'user',
//     success: isSuccess,
//     message: isSuccess ? 'Users synced' : 'Failed syncing users',
//     data: response.data.toString(),
//     timestamp: DateTime.now(),
//   ),
// );

// Get.back();
// AppSnackbar.showSyncResultSnackbar(
//   isSuccess: response.statusCode == 200 || response.statusCode == 201,
// );
// }

Future<void> processQueue() async {
  // // TODO: ADD BULKING POST and call clearAllQueue after ?

  // final queue = local.getQueuedItems(); // dari Hive

  // if (queue.isEmpty) return;

  // for (int i = 0; i < queue.length; i++) {
  //   try {
  //     final item = queue[i]; // send FIFO

  //     // Re-send pending data
  //     log('trying to send ${item.toJson()}');
  //     var response = await remote.postUser(item);
  //     bool isSuccess =
  //         response.statusCode == 200 || response.statusCode == 201;

  //     // Jika berhasil, hapus data dari queue
  //     if (isSuccess) {
  //       await local.deleteQueueAt(i); // Hapus data yg sukses
  //     }

  //     // write to log
  //     logService.addLog(
  //       SyncLog(
  //         type: 'user',
  //         success: isSuccess,
  //         message: isSuccess ? 'Users synced' : 'Failed syncing users',
  //         data: response.data,
  //         timestamp: DateTime.now(),
  //       ),
  //     );
  //   } catch (e) {
  //     // Jika gagal lagi, data tetap ada di queue
  //     // write to log
  //     logService.addLog(
  //       SyncLog(
  //         type: 'user',
  //         success: false,
  //         message: 'Failed syncing users',
  //         data: e.toString(),
  //         timestamp: DateTime.now(),
  //       ),
  //     );
  //   }
  // }
  // }
}
