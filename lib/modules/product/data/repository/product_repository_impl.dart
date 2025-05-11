// data/repository/product_repository_impl.dart
import 'dart:developer';

import 'package:pos_app/core/network/connectivity_service.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/modules/product/data/repository/product_repository.dart';
import 'package:pos_app/modules/product/data/source/product_local.dart';
import 'package:pos_app/modules/product/data/source/product_remote.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remote;
  final ProductLocalDataSource local;
  final ConnectivityService connectivity;

  ProductRepositoryImpl(this.remote, this.local, this.connectivity);

  @override
  Future<List<ProductModel>> getProducts() async {
    final isOnline = await connectivity.isConnected();

    if (!isOnline) {
      return local.getCachedProducts();
    }

    try {
      final products = await remote.fetchProducts();
      await local.updateCache(products);
      return products;
    } catch (e, stackTrace) {
      log("Error fetching products: $e", stackTrace: stackTrace);
      return local.getCachedProducts();
    }
  }

  @override
  Future<void> postProduct(ProductModel product) async {
    if (await connectivity.isConnected()) {
      var response = await remote.postProduct(product);

      // if failed, save to local queue
      if (response.statusCode != 200 && response.statusCode != 201) {
        local.addToQueue(product); // simpan queue lokal
      }
    } else {
      // if offline mode, save to local queue
      local.addToQueue(product);
    }
  }

  @override
  Future<bool> processQueue() async {
    try {
      // TODO: implement bulking?
      // final queue = local.getQueuedItems(); // dari Hive
      // for (final item in queue) {
      //   await remote.postProduct(item);
      // }
      // local.clearQueue();
      return true;
    } catch (_) {
      return false;
    }
  }
}
