import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/modules/transaction/transaction_controller.dart';
import 'package:pos_app/utils/constants/colors.dart';

class TransactionDetailSheet extends StatefulWidget {
  @override
  _TransactionDetailSheetState createState() => _TransactionDetailSheetState();
}

class _TransactionDetailSheetState extends State<TransactionDetailSheet> {
  final trxController = Get.find<TransactionController>();

  double sheetSize = 0.27;
  final double minSize = 0.27;
  late double maxSize;

  late DraggableScrollableController draggableController;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    draggableController = DraggableScrollableController();

    maxSize = minSize + 0.2;

    // Dengarkan perubahan extent saat drag
    draggableController.addListener(() {
      final extent = draggableController.size;
      setState(() {
        isExpanded = extent >= 0.35;
        // isExpanded = extent >= maxSize - 0.05; // Toleransi sedikit
      });
    });
  }

  void toggleSheetSize() {
    if (isExpanded) {
      draggableController.animateTo(
        minSize,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      draggableController.animateTo(
        maxSize,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: draggableController,
      initialChildSize: sheetSize,
      minChildSize: minSize,
      maxChildSize: maxSize,
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
              // Konten scrollable (pakai Expanded)
              Expanded(
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity, // Tambahkan ini
                            child: Align(
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
                                            ),
                                            TextSpan(
                                              text:
                                                  'Rp${NumberFormat("#,##0", "id_ID").format(item.product.hargaJual * item.quantity)}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
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

              // Tombol Checkout tetap di bawah
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
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'Total Harga: Rp${NumberFormat("#,##0", "id_ID").format(trxController.totalPrice.value)}',
                            style: TextStyle(
                              fontSize: 18,
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
                    child: ElevatedButton(
                      onPressed: () {
                        Get.snackbar(
                          'Checkout',
                          'Fitur checkout belum tersedia',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.orange,
                          colorText: Colors.white,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text('Checkout'),
                    ),
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
