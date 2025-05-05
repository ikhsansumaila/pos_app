import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/modules/common/app_bar.dart';
import 'package:pos_app/modules/common/widgets/image.dart';
import 'package:pos_app/modules/transaction/checkout/checkout_controller.dart';
import 'package:pos_app/modules/transaction/select_item/transaction_controller.dart';
import 'package:pos_app/utils/constants/colors.dart';

class CheckoutPage extends StatelessWidget {
  final checkoutController = Get.put(CheckoutController());
  final trxController = Get.find<TransactionController>();

  @override
  Widget build(BuildContext context) {
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
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Nama + Qty
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      cartItem.product.namaBrg,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Qty: ${cartItem.quantity} x Rp${NumberFormat("#,##0", "id_ID").format(cartItem.product.hargaJual)}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                // Harga di kanan bawah
                                Text(
                                  'Rp${NumberFormat("#,##0", "id_ID").format(cartItem.quantity * cartItem.product.hargaJual)}',
                                  style: TextStyle(
                                    fontSize: 18,
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
                        'Rp${NumberFormat("#,##0", "id_ID").format(checkoutController.totalHarga)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Proses pembayaran
                      checkoutController.clear();
                      Get.back(); // atau Get.offAllNamed('/home');
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                    ),
                    child: Text(
                      'Bayar Sekarang',
                      style: TextStyle(fontSize: 18),
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
