import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/common/widgets/image.dart';
import 'package:pos_app/modules/common/widgets/print.dart';
import 'package:pos_app/modules/transaction/common/models/transaction_create_model.dart';
import 'package:pos_app/modules/transaction/selling/controller/checkout_controller.dart';
import 'package:pos_app/modules/transaction/selling/controller/transaction_controller.dart';
import 'package:pos_app/utils/constants/colors.dart';
import 'package:pos_app/utils/formatter.dart';
import 'package:pos_app/utils/responsive_helper.dart';

class CheckoutPage extends StatelessWidget {
  final checkoutController = Get.put(CheckoutController());
  final trxController = Get.find<TransactionController>();

  CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(MediaQuery.of(context).size);
    return Scaffold(
      appBar: MyAppBar(title: 'Checkout'),
      body: Obx(() {
        final items = trxController.items;

        if (items.isEmpty) {
          return Center(child: Text('Belum ada barang untuk di checkout.'));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final cartItem = items[index];
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppImage(
                            url: cartItem.product.gambar,
                            width: responsive.imageSize(100),
                            height: responsive.imageSize(100),
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Nama + Qty
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        cartItem.product.namaBrg ?? '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: responsive.fontSize(18),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Qty: ${cartItem.quantity} x ${AppFormatter.currency((cartItem.product.hargaJual ?? 0).toDouble())}',
                                        style: TextStyle(fontSize: responsive.fontSize(16)),
                                      ),
                                    ],
                                  ),
                                ),
                                // Harga di kanan bawah
                                Text(
                                  AppFormatter.currency(
                                    (cartItem.quantity * (cartItem.product.hargaJual ?? 0))
                                        .toDouble(),
                                  ),
                                  style: TextStyle(
                                    fontSize: responsive.fontSize(18),
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.priceColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (index != items.length - 1) Divider(),
                    ],
                  );
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: TextStyle(fontSize: 18)),
                      Text(
                        AppFormatter.currency(checkoutController.totalHarga),
                        style: TextStyle(
                          fontSize: responsive.fontSize(22),
                          fontWeight: FontWeight.bold,
                          color: AppColors.priceColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      // Proses pembayaran
                      var transType = 'Cash';
                      var transDate = DateTime.now().toIso8601String();
                      var description = '';
                      var transSubtotal = checkoutController.totalHarga;
                      var transDiscount = 0.0;
                      var transTotal = checkoutController.totalHarga;
                      var transPayment = checkoutController.totalHarga;
                      var transBalance = 0.0;
                      var userId = 1;

                      var trxItems =
                          items.map((item) {
                            var subTotal = (item.product.hargaJual ?? 0).toDouble() * item.quantity;
                            return TransactionItemModel(
                              idBarang: item.product.idBrg ?? 0,
                              kodeBarang: item.product.kodeBrg ?? '',
                              description: description,
                              qty: item.quantity,
                              price: (item.product.hargaJual ?? 0).toDouble(),
                              subtotal: subTotal,
                              discount: 0.0,
                              total: subTotal,
                            );
                          }).toList();

                      var trxData = TransactionCreateModel(
                        cacheId: trxController.generateNextCacheId(),
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
                      await checkoutController.createTransaction(trxData);

                      // print pdf after create trx
                      await cetakStrukPDF(items, checkoutController.totalHarga);
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                      // backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    ),
                    child: Text(
                      'Bayar Sekarang',
                      style: TextStyle(fontSize: responsive.fontSize(18)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
