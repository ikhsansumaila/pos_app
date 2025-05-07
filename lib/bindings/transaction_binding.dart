import 'package:get/get.dart';
import 'package:pos_app/modules/transaction/transaction_cashier/transaction_controller.dart';

class TransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TransactionController());
  }
}
