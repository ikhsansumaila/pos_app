import 'package:get/get.dart';
import 'package:pos_app/modules/transaction/selling/controller/transaction_controller.dart';
import 'package:pos_app/modules/transaction/selling/data/models/transaction_create_model.dart';

class CheckoutController extends GetxController {
  final trxController = Get.find<TransactionController>();

  var isLoading = false.obs;

  double get totalHarga {
    return trxController.items.fold(
      0,
      (total, item) => total + ((item.product.hargaJual ?? 0) * (item.quantity ?? 0)),
    );
  }

  void clear() {
    trxController.clearItems();
  }

  Future<void> createTransaction(TransactionCreateModel data) async {
    isLoading(true);
    await trxController.createTransaction(data);
    isLoading(false);
  }
}
