import 'package:get/get.dart';
import 'package:pos_app/modules/user/data/models/user_create_model.dart';
import 'package:pos_app/modules/user/data/repository/user_repository_impl.dart';

class UserQueueController extends GetxController {
  final UserRepositoryImpl repo;

  UserQueueController({required this.repo});

  Future<void> rePostItem(UserCreateModel userItem) async {
    await repo.remote.postUser(userItem);
  }
}
