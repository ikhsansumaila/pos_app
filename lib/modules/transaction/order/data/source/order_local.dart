import 'package:hive/hive.dart';
import 'package:pos_app/core/storage/local_storage_service.dart';
import 'package:pos_app/modules/transaction/order/data/models/order_model.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

class OrderLocalDataSource {
  final Box cacheBox;

  OrderLocalDataSource({required this.cacheBox});

  List<OrderModel> getCachedOrders() {
    final data = cacheBox.get(ORDER_BOX_KEY, defaultValue: []);
    return (data as List).map((e) => OrderModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> update(List<OrderModel> orders) async {
    // add/update/remove cached orders
    await LocalStorageService.updateFromRemote<OrderModel>(
      box: cacheBox,
      apiData: orders,
      deleteNotExist: true,
    );
  }
}
