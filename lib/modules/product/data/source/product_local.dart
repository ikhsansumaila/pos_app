import 'package:hive/hive.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/modules/sync/service/local_storage_service.dart';

class ProductLocalDataSource {
  final Box cacheBox;

  ProductLocalDataSource({required this.cacheBox});

  List<ProductModel> getCachedProducts() {
    return cacheBox.values.map((element) => element as ProductModel).toList();
  }

  Future<LocalStorageUpdateResult> updateCache(List<ProductModel> products) async {
    // add/update/remove cached products
    return await LocalStorageService.updateFromRemote<ProductModel>(
      box: cacheBox,
      apiData: products,
      deleteNotExist: true,
    );
  }
}
