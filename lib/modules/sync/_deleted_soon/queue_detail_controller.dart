import 'package:get/get.dart';
import 'package:pos_app/modules/sync/service/sync_queue_helper.dart';

class SyncQueueDetailController<T> extends GetxController {
  final SyncQueueDataHelper<T> helper;

  SyncQueueDetailController(this.helper);

  final RxList<T> queue = <T>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadQueue();
  }

  void loadQueue() {
    queue.value = helper.getQueuedItems();
  }

  Future<void> clearQueue() async {
    await helper.clearAllQueue();
    loadQueue();
  }

  Future<void> deleteItemAt(int index) async {
    await helper.deleteQueueAt(index);
    loadQueue();
  }

  Future<String> exportQueue() async {
    final items = helper.getQueuedItems();
    final jsonList = items.map(helper.toJson).toList();
    // final content = const JsonEncoder.withIndent('  ').convert(jsonList);
    // final filePath = await FileService.saveToTxtFile(content, fileName: '${helper.key}_queue.txt');
    // return filePath;
    return '';
  }
}
