import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/common/widgets/app_dialog.dart';
import 'package:pos_app/modules/store/data/models/store_model.dart';
import 'package:pos_app/modules/store/data/repository/store_repository.dart';

class StoreController extends GetxController {
  final StoreRepository repository;

  StoreController({required this.repository});

  final searchController = TextEditingController();

  // Form Create Store Controller
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  // final isFormValid = false.obs;

  final isLoading = false.obs;
  final stores = <StoreModel>[].obs;
  final filteredStores = <StoreModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStores();
    searchController.addListener(() => filterstores(searchController.text));
  }

  void fetchStores() async {
    isLoading(true);

    final res = await repository.getStores();
    stores.assignAll(res);
    filteredStores.assignAll(res);

    isLoading(false);
  }

  void filterstores(String query) {
    if (query.isEmpty) {
      filteredStores.assignAll(stores);
    } else {
      final filtered =
          stores
              .where((p) => (p.storeName ?? '').toLowerCase().contains(query.toLowerCase()))
              .toList();
      filteredStores.assignAll(filtered);
    }
  }

  Future<void> createStore() async {
    StoreModel store = StoreModel(
      storeName: nameController.text,
      storeAddress: addressController.text,
      userId: 11.toString(),
    );
    String? errorPost = await repository.postStore(store);
    if (errorPost == null) {
      await AppDialog.showCreateSuccess();
      clearForm();
    } else {
      await AppDialog.show('Terjadi kesalahan', content: errorPost);
    }
  }

  bool get isFormValid => formKey.currentState?.validate() ?? false;

  // void validateForm() {
  //   // set form valid
  //   isFormValid.value = nameController.text.isNotEmpty && addressController.text.isNotEmpty;
  // }

  void clearForm() {
    nameController.clear();
    addressController.clear();
  }
}
