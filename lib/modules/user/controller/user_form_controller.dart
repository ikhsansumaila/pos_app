import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/store/data/models/store_model.dart';
import 'package:pos_app/modules/store/data/repository/store_repository.dart';
import 'package:pos_app/modules/user/data/models/user_create_model.dart';
import 'package:pos_app/modules/user/data/models/user_role_model.dart';
import 'package:pos_app/modules/user/data/repository/user_repository.dart';

class UserFormController extends GetxController {
  final UserRepository userRepo;
  final StoreRepository storeRepo;

  UserFormController({required this.userRepo, required this.storeRepo});

  final RxBool isLoading = false.obs;
  final RxList<UserRoleModel> userRoles = <UserRoleModel>[].obs;
  final RxList<StoreModel> storeList = <StoreModel>[].obs;

  // Form Create User Controller
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final selectedRoleId = RxInt(1);
  final selectedStatus = RxInt(1);
  final selectedStore = Rx<StoreModel?>(null);
  final isPasswordVisible = false.obs;
  final isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserRoles();
    fetchStores();

    // Dengarkan perubahan pada semua text controller
    nameController.addListener(validateForm);
    emailController.addListener(validateForm);
    passwordController.addListener(validateForm);
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void validateForm() {
    bool validForm =
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        GetUtils.isEmail(emailController.text) &&
        passwordController.text.isNotEmpty &&
        passwordController.text.length >= 4 &&
        selectedRoleId.value > 0;

    if (validForm && selectedRoleId.value == 3 && selectedStore.value == null) {
      validForm = false;
    }

    // set form valid
    isFormValid.value = validForm;
  }

  Future<void> createUserIfValid() async {
    log("Create User");
    if (!isFormValid.value) return;

    Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);

    await createUser(
      UserCreateModel(
        cacheId: 0,
        storeId: int.tryParse(selectedStore.value?.id ?? '0') ?? 0,
        nama: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        roleId: selectedRoleId.value,
        status: selectedStatus.value,
        userid: 11,
      ),
    );

    Get.back();
  }

  Future<void> fetchUserRoles() async {
    isLoading(true);

    final res = await userRepo.getRoles();
    userRoles.assignAll(res);

    isLoading(false);
  }

  Future<void> fetchStores() async {
    isLoading(true);

    final res = await storeRepo.getStores();
    storeList.assignAll(res);

    isLoading(false);
  }

  Future<void> createUser(UserCreateModel data) async {
    isLoading(true);
    await userRepo.postUser(data);
    isLoading(false);
  }
}
