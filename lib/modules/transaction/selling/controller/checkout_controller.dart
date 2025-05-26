import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:pos_app/modules/transaction/common/models/transaction_create_model.dart';
import 'package:pos_app/modules/transaction/selling/controller/transaction_controller.dart';

class CheckoutController extends GetxController {
  final trxController = Get.find<TransactionController>();
  var discountController = TextEditingController();
  var totalHarga = 0.0.obs;
  var discount = 0.0.obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    calculateTotal();
  }

  @override
  void onClose() {
    discountController.dispose();
    super.onClose();
  }

  void calculateTotal() {
    final subtotal = trxController.items.fold<double>(
      0,
      (sum, item) => sum + (item.quantity * (item.product.hargaJual ?? 0)),
    );

    // final discount = int.tryParse(discountController.text) ?? 0;
    totalHarga.value = (subtotal - discount.value).clamp(0, double.infinity).toDouble();
  }

  void clear() {
    trxController.clearItems();
  }

  Future<void> createTransaction() async {
    isLoading(true);
    await trxController.createTransaction(totalHarga.value);
    isLoading(false);
  }
}
