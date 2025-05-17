import 'package:pos_app/modules/store/data/models/store_model.dart';

abstract class StoreRepository {
  Future<List<StoreModel>> getStores();
  Future<String?> postStore(StoreModel store);
}
