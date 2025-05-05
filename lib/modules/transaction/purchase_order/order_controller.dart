import 'package:get/get.dart';
import 'package:pos_app/modules/transaction/purchase_order/order_model.dart';

class OrdersController extends GetxController {
  final orders = <Order>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Dummy data
    orders.assignAll([
      Order(
        customerName: 'Budi',
        orderDate: DateTime.now(),
        totalItems: 3,
        totalPrice: 150000,
      ),
      Order(
        customerName: 'Siti',
        orderDate: DateTime.now().subtract(Duration(days: 1)),
        totalItems: 5,
        totalPrice: 230000,
      ),
    ]);
  }
}
