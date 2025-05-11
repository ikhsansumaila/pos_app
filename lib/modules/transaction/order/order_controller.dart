import 'package:get/get.dart';
import 'package:pos_app/modules/transaction/order/data/models/order_model.dart';

class OrdersController extends GetxController {
  final orders = <OrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Dummy data
    orders.assignAll([
      OrderModel(id: 1, customerName: 'Budi', orderDate: DateTime.now(), totalItems: 3, totalPrice: 150000),
      OrderModel(id: 2, customerName: 'Siti', orderDate: DateTime.now().subtract(Duration(days: 1)), totalItems: 5, totalPrice: 230000),
    ]);
  }
}
