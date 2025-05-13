import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/user/data/models/user_model.dart';
import 'package:pos_app/modules/user/data/repository/user_repository.dart';

class UserController extends GetxController {
  final UserRepository repository;

  UserController({required this.repository});

  final RxBool isLoading = false.obs;
  final RxList<UserModel> users = <UserModel>[].obs;
  final RxList<UserModel> filteredUsers = <UserModel>[].obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
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
      final filtered =
          users.where((p) => p.nama.toLowerCase().contains(query.toLowerCase())).toList();
      filteredUsers.assignAll(filtered);
    }
  }
}
