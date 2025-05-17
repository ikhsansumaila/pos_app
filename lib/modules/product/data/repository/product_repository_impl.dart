// data/repository/product_repository_impl.dart
import 'dart:developer';

import 'package:pos_app/core/network/connectivity_service.dart';
import 'package:pos_app/modules/common/widgets/app_dialog.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/modules/product/data/repository/product_repository.dart';
import 'package:pos_app/modules/product/data/source/product_local.dart';
import 'package:pos_app/modules/product/data/source/product_remote.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remote;
  final ProductLocalDataSource local;
  final ConnectivityService connectivity;

  ProductRepositoryImpl({required this.remote, required this.local, required this.connectivity});

  @override
  Future<List<ProductModel>> getProducts(int storeId) async {
    final isOnline = await connectivity.isConnected();

    if (!isOnline) {
      return local.getCachedProducts();
    }

    try {
      final products = await remote.fetchProducts(storeId);
      await local.updateCache(products);
      return products;
    } catch (e, stackTrace) {
      log("Error fetching products: $e", stackTrace: stackTrace);
      AppDialog.show('Terjadi kesalahan', content: 'Error: $e');
      return local.getCachedProducts();
    }
  }

  @override
  Future<String?> postProduct(ProductModel product) async {
    final isOnline = await connectivity.isConnected();

    if (!isOnline) {
      return 'Harap periksa koneksi internet Anda';
    }

    final response = await remote.postProduct(product.toJsonCreate());
    if (response.statusCode != 200 && response.statusCode != 201) {
      return 'Error: ${response.data}';
    }

    return null;
  }
}
