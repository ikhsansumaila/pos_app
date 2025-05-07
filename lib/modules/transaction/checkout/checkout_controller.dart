import 'package:get/get.dart';
import 'package:pos_app/modules/transaction/main/transaction_controller.dart';

class CheckoutController extends GetxController {
  final trxController = Get.find<TransactionController>();

  double get totalHarga {
    return trxController.items.fold(
      0,
      (total, item) => total + (item.product.hargaJual * item.quantity),
    );
  }

  void clear() {
    trxController.clearItems();
  }
}
