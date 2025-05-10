import 'package:pos_app/modules/user/data/models/user_model.dart';

abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<void> postUser(User user);
  Future<bool> processQueue();
}
