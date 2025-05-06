// data/datasources/product_local_datasource.dart
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:pos_app/data/models/product_model.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

class ProductLocalDataSource {
  final Box box;
  ProductLocalDataSource(this.box);
  // ProductLocalDataSource() : box = Hive.box(PRODUCT_BOX_KEY);
  // final Box box;

  List<Product> getCachedProducts() {
    log("get products from cache");
    final data = box.get(PRODUCT_BOX_KEY, defaultValue: []);
    return (data as List)
        .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  void cacheProducts(List<Product> products) {
    log("caching ${products.length} products");
    box.put(PRODUCT_BOX_KEY, products.map((e) => e.toJson()).toList());
  }

  void queueProductPost(Product product) {
    log("queue product post");
    final queue = box.get(POST_QUEUE_KEY, defaultValue: []);
    queue.add(product.toJson());
    box.put(POST_QUEUE_KEY, queue);
  }

  List<Product> getQueuedPosts() {
    log("get queued posts");
    final data = box.get(POST_QUEUE_KEY, defaultValue: []);
    return (data as List)
        .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  void clearQueue() {
    log("clear queue");
    box.put(POST_QUEUE_KEY, []);
  }
}
