import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/common/app_bar.dart';
import 'package:pos_app/modules/product/product_contoller.dart';
import 'package:pos_app/modules/transaction/select_item/transaction_controller.dart';
import 'package:pos_app/modules/transaction/select_item/view/smartphone.dart';
import 'package:pos_app/modules/transaction/select_item/view/tablet.dart';
import 'package:pos_app/utils/responsive_helper.dart';

class TransactionPage extends StatelessWidget {
  final trxController = Get.find<TransactionController>();
  final productController = Get.find<ProductController>();

  TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(MediaQuery.of(context).size);
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: MyAppBar(title: 'Transaksi'),
        // , actions: [CartButton()]),
        body: responsive.isTablet ? TabletLayout() : SmartphoneLayout(),
      ),
      onPopInvokedWithResult: (didPop, popCallback) {
        if (didPop) return;

        Future.microtask(() async {
          final shouldPop = await _showExitConfirmationDialog(context);
          if (shouldPop && context.mounted) {
            trxController.clearItems();
            Get.back();
          }
        });
      },
    );
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    var result =
        await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Keluar Halaman'),
                content: const Text(
                  'Data akan terhapus, Anda yakin ingin meninggalkan halaman ini?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Tidak'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Ya'),
                  ),
                ],
              ),
        ) ??
        false;
    return result;
  }
}
