// controllers/purchase_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/auth/auth_controller.dart';
import 'package:pos_app/modules/common/widgets/app_dialog.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/modules/transaction/common/models/transaction_create_model.dart';
import 'package:pos_app/utils/formatter.dart';

class PurchaseController extends GetxController {
  var purchaseList = <TransactionCreateModel>[].obs;

  final searchController = TextEditingController();
  final descController = TextEditingController();
  final qtyController = TextEditingController();
  final priceController = TextEditingController();

  final trxItems = <TransactionItemModel>[].obs;

  final selectedProduct = Rx<ProductModel?>(null); // ProductModel.obs
  final addedProducts = <ProductModel>[].obs;
  final buttonAddEnable = false.obs;

  @override
  void onInit() {
    super.onInit();

    clearProductSearchForm();
    trxItems.clear();
    addedProducts.clear();
    searchController.clear();
  }

  @override
  void onClose() {
    clearProductSearchForm();
    trxItems.clear();
    addedProducts.clear();
    descController.dispose();
    qtyController.dispose();
    priceController.dispose();
    searchController.dispose();

    super.onClose();
  }

  void clearProductSearchForm() {
    selectedProduct.value = null;
    searchController.clear();
    qtyController.clear();
    priceController.clear();
    buttonAddEnable.value = false;
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

  Future<void> submit() async {
    AuthController authController = Get.find<AuthController>();
    var userLoginData = authController.getUserLoginData();
    if (userLoginData == null) {
      await authController.forceLogout();
      return;
    }

    final subtotal = trxItems.fold(0.0, (sum, i) => sum + i.subtotal);
    final total = trxItems.fold(0.0, (sum, i) => sum + i.total);

    final createModel = TransactionCreateModel(
      cacheId: 0, //TODO: set null
      storeId: userLoginData.storeId ?? 0,
      transType: 'IN',
      transDate: DateTime.now().toIso8601String(),
      description: descController.text,
      transSubtotal: subtotal,
      transDiscount: 0,
      transTotal: total,
      transPayment: total,
      transBalance: 0,
      userId: userLoginData.id,
      items: trxItems.toList(),
    );
    print(createModel.toString());

    Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);
    await Future.delayed(const Duration(seconds: 1));
    Get.back();
    await AppDialog.show('Berhasil', content: 'Transaksi berhasil disimpan');
    // Simulasikan kirim atau simpan lokal
    clearForm();
    Get.back();
  }

  void removeItem(int index) {
    trxItems.removeAt(index);
    addedProducts.removeAt(index);
  }

  void clearForm() {
    clearProductSearchForm();
    trxItems.clear();
    addedProducts.clear();
  }

  void formSearchValidate() {
    double price = AppFormatter.parseCurrency(priceController.text);

    if (selectedProduct.value == null || price == 0 || qtyController.text == '') {
      buttonAddEnable.value = false;
    } else {
      buttonAddEnable.value = true;
    }
  }
}
