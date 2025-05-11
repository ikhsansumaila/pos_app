import 'package:get/get.dart';
import 'package:pos_app/modules/user/data/source/user_local.dart';

class UserQueueController extends GetxController {
  final UserLocalDataSource local;
  UserQueueController(this.local);
}
