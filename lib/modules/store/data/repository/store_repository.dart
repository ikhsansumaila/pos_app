import 'package:pos_app/modules/store/data/models/store_model.dart';

abstract class StoreRepository {
  Future<List<StoreModel>> getStores();
  // Future<void> postStores(StoreCreateModel store);
}
