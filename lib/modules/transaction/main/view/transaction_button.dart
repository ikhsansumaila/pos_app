import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/transaction/main/controller/transaction_controller.dart';
import 'package:pos_app/routes/routes.dart';
import 'package:pos_app/utils/constants/colors.dart';
import 'package:pos_app/utils/formatter.dart';
import 'package:pos_app/utils/responsive_helper.dart';

class TransactionDetailSheet extends StatefulWidget {
  const TransactionDetailSheet({super.key});

  @override
  _TransactionDetailSheetState createState() => _TransactionDetailSheetState();
}

class _TransactionDetailSheetState extends State<TransactionDetailSheet> {
  final trxController = Get.find<TransactionController>();

  final baseSheetSize = 0.27;
  late final DraggableScrollableController draggableController;

  late bool isTabletLandscape;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();

    draggableController = DraggableScrollableController();
    draggableController.addListener(() {
      final extent = draggableController.size;
      if (mounted) {
        setState(() {
          isExpanded = extent > getMinSheetSize();
        });
      }
    });
  }

  /// Hitung ukuran sheet minimum tergantung orientasi/tablet
  double getMinSheetSize() {
    return isTabletLandscape ? baseSheetSize + 0.1 : baseSheetSize;
  }

  double getMaxSheetSize() {
    return getMinSheetSize() + 0.2;
  }

  void toggleSheetSize() {
    if (isExpanded) {
      draggableController.animateTo(
        getMinSheetSize(),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      draggableController.animateTo(
        getMaxSheetSize(),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(MediaQuery.of(context).size);
    isTabletLandscape = responsive.isTablet && responsive.isLandscape;

    return DraggableScrollableSheet(
      controller: draggableController,
      initialChildSize: getMinSheetSize(),
      minChildSize: getMinSheetSize(),
      maxChildSize: getMaxSheetSize(),
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: IconButton(
                              icon: Icon(
                                isExpanded
                                    ? Icons.expand_more
                                    : Icons.expand_less,
                              ),
                              onPressed: toggleSheetSize,
                            ),
                          ),
                          if (trxController.items.isNotEmpty && isExpanded)
                            ...trxController.items.map(
                              (item) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 20,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Text.rich(
                                        textAlign: TextAlign.right,
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${item.product.namaBrg} (${item.quantity}) - ',
                                              style: TextStyle(
                                                fontSize: responsive.fontSize(
                                                  14,
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                              text: AppFormatter.currency(
                                                (item.product.hargaJual *
                                                        item.quantity)
                                                    .toDouble(),
                                              ),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                                fontSize: responsive.fontSize(
                                                  14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Obx(() {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Total Item: (${trxController.totalItems.value})',
                            style: TextStyle(
                              fontSize: responsive.fontSize(14),
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'Total Harga: ${AppFormatter.currency(trxController.totalPrice.value.toDouble())}',
                            style: TextStyle(
                              fontSize: responsive.fontSize(18),
                              fontWeight: FontWeight.bold,
                              color: AppColors.priceColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(
                    width: double.infinity,
                    child: Obx(() {
                      return ElevatedButton(
                        onPressed:
                            trxController.totalItems.value == 0
                                ? null
                                : () => Get.toNamed(AppRoutes.checkout.url),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          'Checkout',
                          style: TextStyle(fontSize: responsive.fontSize(18)),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
