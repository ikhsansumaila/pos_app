import 'package:get/get.dart';
import 'package:pos_app/modules/sync/sync_controller.dart';

class SyncBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SyncController(Get.find(), Get.find()));
  }
}
