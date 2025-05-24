import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/auth/auth_controller.dart';
import 'package:pos_app/modules/common/widgets/app_dialog.dart';
import 'package:pos_app/modules/store/data/models/store_model.dart';
import 'package:pos_app/modules/store/data/repository/store_repository.dart';
import 'package:pos_app/modules/user/data/models/user_model.dart';
import 'package:pos_app/modules/user/data/models/user_role_model.dart';
import 'package:pos_app/modules/user/data/repository/user_repository.dart';

class UserUpdateController extends GetxController {
  final UserRepository userRepo;
  final StoreRepository storeRepo;

  UserUpdateController({required this.userRepo, required this.storeRepo});

  final RxBool isLoading = false.obs;
  final RxList<UserRoleModel> userRoles = <UserRoleModel>[].obs;
  final RxList<StoreModel> storeList = <StoreModel>[].obs;

  // Form Create User Controller
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  UserModel selectedUser = UserModel();
  final selectedRole = Rx<UserRoleModel?>(null);
  final selectedStatus = RxInt(1);
  final selectedStore = Rx<StoreModel?>(null);
  final isPasswordVisible = false.obs;
  final isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchUserRoles();
    // fetchStores();

    // Dengarkan perubahan pada semua text controller
    nameController.addListener(validateForm);
    emailController.addListener(validateForm);
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
    if (selectedUser.id != null) {
      loadInitialData(selectedUser);
    }
  }

  Future<void> loadInitialData(UserModel user) async {
    isLoading(true);
    selectedUser = user;

    await fetchUserRoles();
    await fetchStores();

    setFormData(user);
    isLoading(false);
  }

  void setFormData(UserModel selectedUser) {
    nameController.text = selectedUser.nama ?? '';
    emailController.text = selectedUser.email ?? '';
    selectedStatus.value = selectedUser.status ?? 1;
    if (selectedRole.value != null && userRoles.isNotEmpty) {
      var rolematch = userRoles.where((role) => role.id == selectedRole.value!.id);
      if (rolematch.isNotEmpty) {
        selectedRole.value = rolematch.first;
      }
    }
    if (selectedUser.storeId != null && storeList.isNotEmpty) {
      var storematch = storeList.where((store) => store.id == selectedUser.storeId);
      if (storematch.isNotEmpty) {
        selectedStore.value = storematch.first;
      }
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void validateForm() {
    bool validForm =
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        GetUtils.isEmail(emailController.text) &&
        selectedRole.value?.id != null &&
        selectedRole.value!.id > 0;

    if (!validForm) {
      isFormValid.value = false;
      return;
    }

    if (selectedRole.value!.id == 3 && selectedStore.value == null) {
      validForm = false;
    }

    // set form valid
    isFormValid.value = validForm;
  }

  Future<void> fetchUserRoles() async {
    // isLoading(true);

    final res = await userRepo.getRoles();
    log("fetch user roles: $res");
    userRoles.assignAll(res);

    // isLoading(false);
  }

  Future<void> fetchStores() async {
    // isLoading(true);

    final res = await storeRepo.getStores();
    storeList.assignAll(res);

    // isLoading(false);
  }

  Future<void> createUser() async {
    AuthController authController = Get.find<AuthController>();
    var userLoginData = authController.getUserLoginData();
    if (userLoginData == null) {
      await AppDialog.show('Terjadi kesalahan', content: 'User login tidak ditemukan');
      return;
    }

    UserModel data = UserModel(
      cacheId: userRepo.generateNextCacheId(),
      storeId: int.tryParse(selectedStore.value?.id ?? '0') ?? 0,
      roleName: selectedRole.value?.role ?? '',
      nama: nameController.text,
      email: emailController.text,
      roleId: selectedRole.value?.id ?? 0,
      status: selectedStatus.value,
      userId: userLoginData.id,
    );

    String? errorPost = await userRepo.postUser(data);
    if (errorPost == null) {
      await AppDialog.showCreateSuccess();
      clearForm();
    } else {
      await AppDialog.show('Terjadi kesalahan', content: errorPost);
    }
  }

  void clearForm() {
    selectedRole.value = null;
    selectedStore.value = null;
    selectedStatus.value = 1;
    nameController.clear();
    emailController.clear();
  }
}
