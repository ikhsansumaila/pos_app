import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/modules/product/data/repository/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository repository;
  ProductController(this.repository);

  final products = <Product>[].obs;
  final filteredProducts = <Product>[].obs;
  final isLoading = false.obs;

  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    searchController.addListener(() => filterProducts(searchController.text));
  }

  void fetchProducts() async {
    isLoading(true);

    final res = await repository.getProducts();
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
              .where(
                (p) => p.namaBrg.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
      filteredProducts.assignAll(filtered);
    }
  }

  Future<bool> addProduct(Product product) async {
    isLoading(true);

    // return repository.postProduct(product);
    var result = Future.delayed(Duration(seconds: 2)).then((value) => true);

    isLoading(false);
    return result;
  }
}
