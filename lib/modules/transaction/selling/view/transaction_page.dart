import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/common/widgets/app_dialog.dart';
import 'package:pos_app/modules/product/controller/product_contoller.dart';
import 'package:pos_app/modules/transaction/selling/controller/transaction_controller.dart';
import 'package:pos_app/modules/transaction/selling/view/list_smartphone.dart';
import 'package:pos_app/modules/transaction/selling/view/list_tablet.dart';
import 'package:pos_app/utils/responsive_helper.dart';

class TransactionSellingPage extends StatelessWidget {
  final trxController = Get.find<TransactionController>();
  final productController = Get.find<ProductController>();

  TransactionSellingPage({super.key});

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
          final shouldPop = await AppDialog.showExitConfirmationDialog(context);
          if (shouldPop && context.mounted) {
            trxController.clearItems();
            Get.back();
          }
        });
      },
    );
  }
}
