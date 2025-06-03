import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_app/core/controller_provider.dart';
import 'package:pos_app/modules/auth/auth_controller.dart';
import 'package:pos_app/modules/auth/auth_model.dart';
import 'package:pos_app/modules/common/widgets/app_dialog.dart';
import 'package:pos_app/modules/common/widgets/print.dart';
import 'package:pos_app/modules/store/controller/store_controller.dart';
import 'package:pos_app/modules/store/data/models/store_model.dart';
import 'package:pos_app/modules/transaction/common/models/transaction_create_model.dart';
// import 'package:pos_app/modules/transaction/common/models/transaction_create_model.dart';
import 'package:pos_app/modules/transaction/selling/controller/transaction_controller.dart';
import 'package:pos_app/modules/transaction/selling/view/transaction_success_page.dart';
import 'package:pos_app/utils/common_helper.dart';
import 'package:pos_app/utils/constants/constant.dart';
import 'package:pos_app/utils/formatter.dart';

class CheckoutController extends GetxController {
  final trxController = Get.find<TransactionController>();
  final storeController = ControllerProvider.findOrPut(StoreController(repository: Get.find()));

  final TextEditingController discountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountPaidController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  UserLoginModel? userLoginData;
  StoreModel? store;

  var totalHarga = 0.0.obs;
  var discount = 0.0.obs;
  var subtotal = 0.0.obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    calculateTotal();
  }

  @override
  void onClose() {
    discountController.dispose();
    descriptionController.dispose();
    amountPaidController.dispose();
    super.onClose();
  }

  void calculateTotal() {
    final sub = trxController.items.fold<double>(
      0,
      (sum, item) => sum + (item.quantity * (item.product.hargaJual ?? 0)),
    );

    subtotal.value = sub;

    // final discount = int.tryParse(discountController.text) ?? 0;
    totalHarga.value = (sub - discount.value).clamp(0, double.infinity).toDouble();
  }

  void clear() {
    trxController.clearItems();
  }

  Future<void> doPayment(BuildContext context) async {
    final result = await showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi Pembayaran'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Keterangan'),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: amountPaidController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(labelText: 'Total Dibayarkan', prefixText: 'Rp'),
                  onChanged: (value) {
                    double paidValue = double.tryParse(value) ?? 0;
                    amountPaidController.text = AppFormatter.currency(
                      paidValue.toDouble(),
                      withSymbol: false,
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                descriptionController.clear();
                amountPaidController.clear();
                Get.back();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                double amountPaid = AppFormatter.parseCurrency(amountPaidController.text);

                if (amountPaid < totalHarga.value) {
                  showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          title: Text("Peringatan"),
                          content: Text('Jumlah yang dibayarkan tidak boleh kurang dari total.'),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(result: false),
                              child: const Text("Tutup"),
                            ),
                          ],
                        ),
                  );
                  return;
                }
                Get.back(result: true);
              },
              child: Text('Konfirmasi'),
            ),
          ],
        );
      },
    );
    if (result != null) {
      isLoading(true);
      final result = await createTransaction();
      isLoading(false);

      if (!result) {
        await AppDialog.show(
          'Terjadi kesalahan',
          content: 'Gagal membuat transaksi. Silakan coba lagi.',
        );
        return;
      }

      await Get.to(
        () => TransactionSuccessPage(
          amountPaid: AppFormatter.parseCurrency(amountPaidController.text),
          totalPrice: totalHarga.value,
          transactionDate: AppFormatter.dateTime(DateTime.now()),
          onPrintPressed: () async {
            await printOut();
            // clear();
          },
        ),
      );
    }
  }

  Future<bool> createTransaction() async {
    AuthController authController = Get.find<AuthController>();
    var userLoginData = authController.getUserLoginData();
    if (userLoginData == null) {
      await authController.forceLogout();
      return false;
    }

    if (userLoginData.role == AppUserRole.cashier && userLoginData.storeId == null) {
      await AppDialog.show(
        'Terjadi kesalahan',
        content: 'User tidak terdaftar di toko, silakan login dengan akun lain',
      );
      return false;
    }

    // Proses pembayaran
    var transType = 'OUT';
    var transDate = DateTime.now().toIso8601String();
    var description = descriptionController.text;
    var transSubtotal = totalHarga.value;
    var transDiscount = discount.value;
    var transTotal = totalHarga.value;
    var transPayment = totalHarga.value;
    var transBalance = 0.0;
    var userId = userLoginData.id;
    var storeId = userLoginData.storeId!;

    var trxItems =
        trxController.items.map((item) {
          var subTotal = (item.product.hargaJual ?? 0).toDouble() * item.quantity;
          return TransactionItemModel(
            idBarang: item.product.idBrg ?? 0,
            kodeBarang: item.product.kodeBrg ?? '',
            description: '',
            qty: item.quantity,
            price: (item.product.hargaJual ?? 0).toDouble(),
            subtotal: subTotal,
            discount: 0.0,
            total: subTotal,
          );
        }).toList();

    var trxData = TransactionCreateModel(
      cacheId: trxController.repository.generateNextCacheId(),
      storeId: storeId,
      transType: transType,
      transDate: transDate,
      description: description,
      transSubtotal: transSubtotal,
      transDiscount: transDiscount,
      transTotal: transTotal,
      transPayment: transPayment,
      transBalance: transBalance,
      userId: userId,
      items: trxItems,
    );

    return await trxController.createTransaction(trxData);
  }

  Future<void> printOut() async {
    userLoginData = authController.getUserLoginData();
    // set store from user login data
    store = storeController.stores.firstWhereOrNull(
      (s) => s.id == userLoginData?.storeId?.toString(),
    );
    printJson(store);
    return await cetakStrukPDF(
      trxController.items,
      userName: userLoginData?.nama ?? '-',
      storeName: store?.storeName ?? '-',
      storeAddress: store?.storeAddress ?? '-',
      subTotal: subtotal.value,
      discount: discount.value,
      totalPayment: totalHarga.value,
    );
  }
}
