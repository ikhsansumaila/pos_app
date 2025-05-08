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
  Future<List<Product>> getProducts() async {
    if (await connectivity.isConnected()) {
      log("Internet is on");
      try {
        final products = await remote.fetchProducts();
        await local.updateCache(products);
        return products;
      } catch (e) {
        log("Error fetching products: $e");
        return local.getCachedProducts();
      }
    } else {
      log("Internet is off");
      return local.getCachedProducts();
    }
  }

  @override
  Future<void> postProduct(Product product) async {
    if (await connectivity.isConnected()) {
      await remote.postProduct(product);
      await processQueue(); // send pending posts
    } else {
      local.queueProductPost(product); // simpan queue lokal
    }
  }

  @override
  Future<bool> processQueue() async {
    try {
      final queue = local.getQueuedPosts(); // dari Hive
      for (final item in queue) {
        await remote.postProduct(item);
      }
      local.clearQueue();
      return true;
    } catch (_) {
      return false;
    }
  }
}
