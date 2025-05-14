import 'package:pos_app/modules/user/data/models/user_model.dart';
import 'package:pos_app/modules/user/data/models/user_role_model.dart';

abstract class UserRepository {
  Future<List<UserModel>> getUsers();
  Future<void> postUser(UserModel user);
  Future<List<UserRoleModel>> getRoles();
  int generateNextCacheId();
}
