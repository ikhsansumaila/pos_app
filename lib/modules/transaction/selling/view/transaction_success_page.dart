import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/common/scrollable_page.dart';
import 'package:pos_app/utils/constants/colors.dart';
import 'package:pos_app/utils/formatter.dart';

class TransactionSuccessPage extends StatelessWidget {
  final VoidCallback onPrintPressed;
  final double totalPrice;
  final double amountPaid;
  final String transactionDate;

  const TransactionSuccessPage({
    super.key,
    required this.totalPrice,
    required this.amountPaid,
    required this.transactionDate,
    required this.onPrintPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      bodyColor: Colors.white,
      appBar: AppBar(title: const Text('Transaksi Berhasil'), centerTitle: true),
      mainWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Center(
            child: Column(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 120),
                SizedBox(height: 20),
                Text(
                  'Transaksi Berhasil!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(transactionDate, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Transaksi: ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      AppFormatter.currency(totalPrice),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Yang dibayarkan: ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      AppFormatter.currency(amountPaid),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kembalian: ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      AppFormatter.currency(amountPaid - totalPrice),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: Column(
              children: [
                Text('Terima kasih!', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  icon: const Icon(Icons.print),
                  label: const Text(
                    'Cetak Struk',
                    style: TextStyle(fontSize: 16, color: AppColors.primary),
                  ),
                  onPressed: onPrintPressed,
                  style: OutlinedButton.styleFrom(
                    iconColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                    side: BorderSide(color: AppColors.primary, width: 1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      fixedBottomWidget: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => Get.back(),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Text('Selesai', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
