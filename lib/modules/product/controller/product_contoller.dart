import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/common/widgets/app_dialog.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/modules/product/data/repository/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository repository;
  ProductController({required this.repository});

  final products = <ProductModel>[].obs;
  final filteredProducts = <ProductModel>[].obs;
  final isLoading = false.obs;
  final storeId = 1;

  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    searchController.addListener(() => filterProducts(searchController.text));
  }

  void fetchProducts() async {
    isLoading(true);

    final res = await repository.getProducts(storeId);
    products.assignAll(res);
    filteredProducts.assignAll(res);

    isLoading(false);
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      final filtered =
          products
              .where((p) => (p.namaBrg ?? '').toLowerCase().contains(query.toLowerCase()))
              .toList();
      filteredProducts.assignAll(filtered);
    }
  }

  Future<void> addProduct(ProductModel product) async {
    String? errorPost = await repository.postProduct(product);
    if (errorPost == null) {
      await AppDialog.showCreateSuccess();
      clearForm();
    } else {
      await AppDialog.show('Terjadi kesalahan', content: errorPost);
    }
  }

  void clearForm() {}
}
