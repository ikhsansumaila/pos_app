import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/user/data/models/user_create_model.dart';
import 'package:pos_app/modules/user/data/models/user_model.dart';
import 'package:pos_app/modules/user/data/repository/user_repository.dart';

class UserController extends GetxController {
  UserController(this.repository);
  final UserRepository repository;

  final RxList<UserModel> users = <UserModel>[].obs;
  final RxList<UserModel> filteredUsers = <UserModel>[].obs;
  final RxBool isLoading = false.obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    // searchController.addListener(() => filterProducts(searchController.text));
  }

  void fetchUsers() async {
    isLoading(true);

    final res = await repository.getUsers();
    users.assignAll(res);
    filteredUsers.assignAll(res);

    isLoading(false);
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.assignAll(users);
    } else {
      final filtered = users.where((p) => p.nama.toLowerCase().contains(query.toLowerCase())).toList();
      filteredUsers.assignAll(filtered);
    }
  }

  Future<void> createUser(Map<String, dynamic> data) async {
    isLoading(true);
    await repository.postUser(UserCreateModel.fromJson(data));
    isLoading(false);
  }
}
