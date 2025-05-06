import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/data/models/product_model.dart';
import 'package:pos_app/modules/common/widgets/icon_button.dart';
import 'package:pos_app/modules/common/widgets/image.dart';
import 'package:pos_app/modules/product/product_contoller.dart';
import 'package:pos_app/modules/transaction/select_item/transaction_controller.dart';
import 'package:pos_app/modules/transaction/select_item/view/transaction_button.dart';
import 'package:pos_app/routes.dart';
import 'package:pos_app/utils/constants/colors.dart';
import 'package:pos_app/utils/responsive_helper.dart';

class SmartphoneLayout extends StatelessWidget {
  SmartphoneLayout({super.key});

  final trxController = Get.find<TransactionController>();
  final productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(MediaQuery.of(context).size);
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.blue.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: _buildSearchBar(responsive),
              ),
              Expanded(
                child: Obx(() {
                  if (productController.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 50.0,
                      left: 8,
                      right: 8,
                    ),
                    child: GridView.builder(
                      itemCount: productController.filteredProducts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 0.1,
                        mainAxisSpacing: 0.1,
                        childAspectRatio: 1.5,
                      ),
                      itemBuilder: (context, index) {
                        final product =
                            productController.filteredProducts[index];
                        return _buildProductCard(product, responsive);
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),

        // Draggable Bottom Sheet
        TransactionDetailSheet(),
      ],
    );
  }

  Widget _buildSearchBar(ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white.withOpacity(0.9),
      ),
      child: TextField(
        controller: productController.searchController,
        style: TextStyle(
          color: Colors.black,
          fontSize: responsive.fontSize(16),
        ),
        decoration: InputDecoration(
          hintText: 'Cari Barang...',
          hintStyle: TextStyle(
            color: Colors.blueGrey,
            fontSize: responsive.fontSize(16),
          ),
          prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product, ResponsiveHelper responsive) {
    double circularRadius = 14;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(circularRadius),
      ),
      elevation: 8,
      shadowColor: Colors.black26,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(circularRadius),
        ),
        child: GetBuilder(
          init: trxController,
          builder: (data) {
            final quantity = data.getQuantity(product.idBrg);
            int stock = 10;

            bool buttonAddEnabled = stock > 0 && quantity < stock;
            bool buttonRemoveEnabled = stock > 0 && quantity > 0;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ROW: Gambar dan informasi
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppImage(url: product.gambar, width: 40, height: 40),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.namaBrg,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 8,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Rp${NumberFormat("#,##0", "id_ID").format(product.hargaJual)}',
                              style: TextStyle(
                                color: AppColors.priceColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '(Stok: $stock)',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap:
                            stock == 0
                                ? null
                                : () {
                                  Get.toNamed(
                                    AppRoutes.stockMutation,
                                    arguments: product,
                                  );
                                },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.call_split,
                              color:
                                  stock == 0 ? Colors.grey : AppColors.primary,
                              size: 12,
                            ),
                            const SizedBox(width: 2), // spasi minimal
                            Text(
                              'Pecah Stok',
                              style: TextStyle(
                                color:
                                    stock == 0
                                        ? Colors.grey
                                        : AppColors.primary,
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Tombol + / - dan qty
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppIconButton(
                            onPressed:
                                buttonRemoveEnabled
                                    ? () => data.removeItem(product)
                                    : null,
                            icon: Icons.remove_circle,
                            color:
                                buttonRemoveEnabled ? Colors.red : Colors.grey,
                            size: 12,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            quantity.toString(),
                            style: TextStyle(
                              fontSize: 8,
                              color: stock == 0 ? Colors.grey : Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 8),
                          AppIconButton(
                            onPressed:
                                buttonAddEnabled
                                    ? () => data.addItem(product)
                                    : null,
                            icon: Icons.add_circle,
                            color:
                                buttonAddEnabled
                                    ? AppColors.primary
                                    : Colors.grey,
                            size: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
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
