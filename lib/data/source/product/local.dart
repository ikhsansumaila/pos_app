// data/datasources/product_local_datasource.dart
import 'package:hive/hive.dart';
import 'package:pos_app/data/models/product_model.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

class ProductLocalDataSource {
  // final Box box;
  // ProductLocalDataSource(this.box);
  ProductLocalDataSource() : box = Hive.box(PRODUCT_BOX_KEY);
  final Box box;

  List<Product> getCachedProducts() {
    final data = box.get(PRODUCT_BOX_KEY, defaultValue: []);
    return (data as List)
        .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  void cacheProducts(List<Product> products) {
    box.put(PRODUCT_BOX_KEY, products.map((e) => e.toJson()).toList());
  }

  void queueProductPost(Product product) {
    final queue = box.get(POST_QUEUE_KEY, defaultValue: []);
    queue.add(product.toJson());
    box.put(POST_QUEUE_KEY, queue);
  }

  List<Product> getQueuedPosts() {
    final data = box.get(POST_QUEUE_KEY, defaultValue: []);
    return (data as List)
        .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  void clearQueue() {
    box.put(POST_QUEUE_KEY, []);
  }
}
