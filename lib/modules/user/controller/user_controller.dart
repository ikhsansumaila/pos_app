import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/store/store_model.dart';
import 'package:pos_app/modules/user/data/models/user_create_model.dart';
import 'package:pos_app/modules/user/data/models/user_model.dart';
import 'package:pos_app/modules/user/data/repository/user_repository.dart';

class UserController extends GetxController {
  final UserRepository repository;

  UserController({required this.repository});

  final RxList<UserModel> users = <UserModel>[].obs;
  final RxList<UserModel> filteredUsers = <UserModel>[].obs;
  final RxBool isLoading = false.obs;
  final TextEditingController searchController = TextEditingController();

  // Form Create User Controller
  final formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final selectedRoleId = RxInt(1);
  final selectedStatus = RxInt(1);
  final RxList<StoreModel> stores = <StoreModel>[].obs;
  final selectedStore = Rx<StoreModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    // searchController.addListener(() => filterProducts(searchController.text));
  }

  bool get isFormValid {
    bool validForm =
        namaController.text.isNotEmpty && emailController.text.isNotEmpty;

    if (validForm && selectedRoleId.value == 3 && selectedStore.value == null) {
      validForm = false;
    }
    return validForm;
  }

  Future<void> createUserIfValid() async {
    log("Create User");
    if (!isFormValid) return;

    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    await createUser(
      UserCreateModel(
        storeId: selectedStore.value?.id ?? 0,
        nama: namaController.text,
        email: emailController.text,
        roleId: selectedRoleId.value,
        status: selectedStatus.value,
        userid: 11,
      ),
    );

    Get.back();
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
          users
              .where((p) => p.nama.toLowerCase().contains(query.toLowerCase()))
              .toList();
      filteredUsers.assignAll(filtered);
    }
  }

  Future<void> createUser(UserCreateModel data) async {
    isLoading(true);
    await repository.postUser(data);
    isLoading(false);
  }
}
