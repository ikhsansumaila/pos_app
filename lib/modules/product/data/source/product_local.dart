import 'package:hive/hive.dart';
import 'package:pos_app/core/storage/local_storage_service.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

class ProductLocalDataSource {
  final Box cacheBox;

  ProductLocalDataSource({required this.cacheBox});

  List<ProductModel> getCachedProducts() {
    final data = cacheBox.get(PRODUCT_BOX_KEY, defaultValue: []);
    return (data as List).map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> updateCache(List<ProductModel> products) async {
    // add/update/remove cached products
    await LocalStorageService.updateFromRemote<ProductModel>(
      box: cacheBox,
      apiData: products,
      deleteNotExist: true,
    );
  }
}
