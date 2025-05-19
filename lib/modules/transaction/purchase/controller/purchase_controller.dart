// controllers/purchase_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/modules/transaction/common/models/transaction_create_model.dart';
import 'package:pos_app/utils/formatter.dart';

class PurchaseController extends GetxController {
  var purchaseList = <TransactionCreateModel>[].obs;
  // var currentItems = <TransactionItemModel>[].obs;

  final searchController = TextEditingController();
  final descController = TextEditingController();
  final qtyController = TextEditingController();
  final priceController = TextEditingController();

  final trxItems = <TransactionItemModel>[].obs;

  final selectedProduct = Rx<ProductModel?>(null); // ProductModel.obs
  final addedProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    clearProduct();
    trxItems.clear();
    addedProducts.clear();
    searchController.text = '-';
  }

  @override
  void onClose() {
    clearProduct();
    trxItems.clear();
    addedProducts.clear();
    descController.dispose();
    qtyController.dispose();
    priceController.dispose();
    searchController.dispose();

    super.onClose();
  }

  void clearProduct() {
    selectedProduct.value = null;
    searchController.clear();
    qtyController.clear();
    priceController.clear();
  }

  void addItem(ProductModel product) {
    final qty = int.tryParse(qtyController.text) ?? 0;
    final price = AppFormatter.parseCurrency(priceController.text);
    final subtotal = qty * price;

    trxItems.add(
      TransactionItemModel(
        idBarang: product.idBrg!,
        kodeBarang: product.kodeBrg!,
        description: descController.text,
        qty: qty,
        price: price,
        subtotal: subtotal,
        discount: 0,
        total: subtotal,
      ),
    );
    addedProducts.add(product);

    descController.clear();
    qtyController.clear();
    priceController.clear();
    selectedProduct.value = null;
  }

  void submit() {
    final subtotal = trxItems.fold(0.0, (sum, i) => sum + i.subtotal);
    final total = trxItems.fold(0.0, (sum, i) => sum + i.total);

    final model = TransactionCreateModel(
      cacheId: 0, //TODO: set null
      transType: 'purchase',
      transDate: DateTime.now().toIso8601String(),
      description: descController.text,
      transSubtotal: subtotal,
      transDiscount: 0,
      transTotal: total,
      transPayment: total,
      transBalance: 0,
      userId: 11, // TODO: Ganti dengan id user yang sesuai
      items: trxItems.toList(),
    );

    // Simulasikan kirim atau simpan lokal
    print(model.toString());
    Get.back();
  }

  void removeItem(int index) {
    trxItems.removeAt(index);
    addedProducts.removeAt(index);
  }
}
