import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/auth/auth_controller.dart';
import 'package:pos_app/modules/common/widgets/app_dialog.dart';
import 'package:pos_app/modules/store/data/models/store_model.dart';
import 'package:pos_app/modules/store/data/repository/store_repository.dart';
import 'package:pos_app/modules/user/data/models/user_model.dart';
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

  final selectedRole = Rx<UserRoleModel?>(null);
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

  Future<void> createUser() async {
    AuthController authController = Get.find<AuthController>();
    var userLoginData = authController.getUserLoginData();
    if (userLoginData == null) {
      await authController.forceLogout();
      return;
    }

    UserModel data = UserModel(
      cacheId: userRepo.generateNextCacheId(),
      storeId: int.tryParse(selectedStore.value?.id ?? '0') ?? 0,
      roleName: selectedRole.value?.role ?? '',
      nama: nameController.text,
      email: emailController.text,
      password: passwordController.text,
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
    passwordController.clear();
  }
}
