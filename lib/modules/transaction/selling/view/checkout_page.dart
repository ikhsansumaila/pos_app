import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/common/widgets/image.dart';
import 'package:pos_app/modules/transaction/selling/controller/checkout_controller.dart';
import 'package:pos_app/modules/transaction/selling/controller/transaction_controller.dart';
import 'package:pos_app/utils/constants/colors.dart';
import 'package:pos_app/utils/formatter.dart';
import 'package:pos_app/utils/responsive_helper.dart';
import 'package:pos_app/utils/styles.dart';

class CheckoutPage extends StatelessWidget {
  final checkoutController = Get.put(CheckoutController());
  final trxController = Get.find<TransactionController>();

  CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Diskon', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  TextField(
                    controller: checkoutController.discountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: AppStyles.textFieldDecoration(
                      hintText: 'Masukkan diskon (misal: 10.000)',
                      prefixText: 'Rp',
                    ),
                    onChanged: (value) {
                      double discountValue = double.tryParse(value) ?? 0;

                      // Prevent discount from exceeding total
                      if (discountValue > checkoutController.totalHarga.value) {
                        discountValue = checkoutController.discount.value;
                        checkoutController.discountController.text = AppFormatter.currency(
                          discountValue.toDouble(),
                          withSymbol: false,
                        );
                        return;
                      }

                      checkoutController.discount.value = discountValue.toDouble();
                      checkoutController.discountController.text = AppFormatter.currency(
                        discountValue.toDouble(),
                        withSymbol: false,
                      );

                      checkoutController.calculateTotal();
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sub Total', style: TextStyle(fontSize: 14)),
                      Obx(
                        () => Text(
                          AppFormatter.currency(checkoutController.subtotal.value),
                          style: TextStyle(
                            fontSize: responsive.fontSize(20),
                            fontWeight: FontWeight.bold,
                            color: AppColors.priceColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Diskon', style: TextStyle(fontSize: 14)),
                      Obx(
                        () => Text(
                          AppFormatter.currency(checkoutController.discount.value),
                          style: TextStyle(
                            fontSize: responsive.fontSize(20),
                            fontWeight: FontWeight.bold,
                            color: AppColors.priceColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: TextStyle(fontSize: 14)),
                      Obx(
                        () => Text(
                          AppFormatter.currency(checkoutController.totalHarga.value),
                          style: TextStyle(
                            fontSize: responsive.fontSize(20),
                            fontWeight: FontWeight.bold,
                            color: AppColors.priceColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 35),
                  ElevatedButton(
                    onPressed: () async => await checkoutController.doPayment(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
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
