import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/common/widgets/icon_button.dart';
import 'package:pos_app/modules/common/widgets/image.dart';
import 'package:pos_app/modules/common/widgets/search_bar_widget.dart';
import 'package:pos_app/modules/product/controller/product_contoller.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/modules/product/view/product_detail_page.dart';
import 'package:pos_app/modules/transaction/selling/controller/transaction_controller.dart';
import 'package:pos_app/modules/transaction/selling/view/transaction_button.dart';
import 'package:pos_app/routes/routes.dart';
import 'package:pos_app/utils/constants/colors.dart';
import 'package:pos_app/utils/formatter.dart';
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
                child: AppSearchBar(
                  controller: productController.searchController,
                  hintText: 'Cari Barang...',
                ),
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
                    padding: const EdgeInsets.only(bottom: 50.0, left: 8, right: 8),
                    child: GridView.builder(
                      itemCount: productController.filteredProducts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 0.1,
                        mainAxisSpacing: 0.1,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        final product = productController.filteredProducts[index];
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

  Widget _buildProductCard(ProductModel product, ResponsiveHelper responsive) {
    double circularRadius = 14;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(circularRadius)),
        elevation: 8,
        shadowColor: Colors.black26,
        child: GetBuilder(
          init: trxController,
          builder: (data) {
            final quantity = data.getQuantity(product.idBrg ?? 0);
            int stock = product.stok ?? 0;

            bool buttonAddEnabled = stock > 0 && quantity < stock;
            bool buttonRemoveEnabled = stock > 0 && quantity > 0;

            // Konten bawah (nama, harga, stok, tombol)
            return GestureDetector(
              onTap: () {
                Get.to(() => ProductDetailPage(product: product));
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppImage(
                      url: product.gambar,
                      width: double.infinity,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 8),
                    Text(
                      product.namaBrg ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      AppFormatter.currency((product.hargaJual ?? 0).toDouble()),
                      style: TextStyle(
                        color: AppColors.priceColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('(Stok: $stock)', style: TextStyle(color: Colors.black87, fontSize: 11)),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap:
                              stock == 0
                                  ? null
                                  : () {
                                    Get.toNamed(AppRoutes.stockMutation.url, arguments: product);
                                  },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.call_split,
                                color: stock == 0 ? Colors.grey : AppColors.primary,
                                size: 12,
                              ),
                              const SizedBox(width: 2), // spasi minimal
                              Text(
                                'Pecah Stok',
                                style: TextStyle(
                                  color: stock == 0 ? Colors.grey : AppColors.primary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            AppIconButton(
                              onPressed:
                                  buttonRemoveEnabled ? () => data.removeItem(product) : null,
                              icon: Icons.remove_circle,
                              color: buttonRemoveEnabled ? Colors.red : Colors.grey,
                              buttonSize: 20,
                              iconSize: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              quantity.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: stock == 0 ? Colors.grey : Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            AppIconButton(
                              onPressed: buttonAddEnabled ? () => data.addItem(product) : null,
                              icon: Icons.add_circle,
                              color: buttonAddEnabled ? AppColors.primary : Colors.grey,
                              buttonSize: 20,
                              iconSize: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
    // double circularRadius = 14;

    // return Card(
    //   margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(circularRadius)),
    //   elevation: 8,
    //   shadowColor: Colors.black26,
    //   child: Container(
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.circular(circularRadius),
    //     ),
    //     child: GetBuilder(
    //       init: trxController,
    //       builder: (data) {
    //         final quantity = data.getQuantity(product.idBrg ?? 0);
    //         int stock = 10;

    //         bool buttonAddEnabled = stock > 0 && quantity < stock;
    //         bool buttonRemoveEnabled = stock > 0 && quantity > 0;
    //         return Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               // ROW: Gambar dan informasi
    //               Row(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   AppImage(url: product.gambar, width: 40, height: 40),
    //                   const SizedBox(width: 8),
    //                   Expanded(
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Text(
    //                           product.namaBrg ?? '',
    //                           style: TextStyle(
    //                             fontWeight: FontWeight.bold,
    //                             fontSize: 8,
    //                             color: Colors.black87,
    //                           ),
    //                         ),
    //                         Text(
    //                           AppFormatter.currency((product.hargaJual ?? 0).toDouble()),
    //                           style: TextStyle(
    //                             color: AppColors.priceColor,
    //                             fontSize: 10,
    //                             fontWeight: FontWeight.bold,
    //                           ),
    //                         ),
    //                         Text(
    //                           'Stok: ${product.stok ?? 0}',
    //                           style: TextStyle(color: Colors.black87, fontSize: 8),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   InkWell(
    //                     onTap:
    //                         stock == 0
    //                             ? null
    //                             : () {
    //                               Get.toNamed(AppRoutes.stockMutation.url, arguments: product);
    //                             },
    //                     child: Row(
    //                       mainAxisSize: MainAxisSize.min,
    //                       children: [
    //                         Icon(
    //                           Icons.call_split,
    //                           color: stock == 0 ? Colors.grey : AppColors.primary,
    //                           size: 12,
    //                         ),
    //                         const SizedBox(width: 2), // spasi minimal
    //                         Text(
    //                           'Pecah Stok',
    //                           style: TextStyle(
    //                             color: stock == 0 ? Colors.grey : AppColors.primary,
    //                             fontSize: 8,
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                   // Tombol + / - dan qty
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.start,
    //                     children: [
    //                       AppIconButton(
    //                         onPressed: buttonRemoveEnabled ? () => data.removeItem(product) : null,
    //                         icon: Icons.remove_circle,
    //                         color: buttonRemoveEnabled ? Colors.red : Colors.grey,
    //                         size: 12,
    //                       ),
    //                       const SizedBox(width: 8),
    //                       Text(
    //                         quantity.toString(),
    //                         style: TextStyle(
    //                           fontSize: 8,
    //                           color: stock == 0 ? Colors.grey : Colors.black87,
    //                         ),
    //                       ),
    //                       const SizedBox(width: 8),
    //                       AppIconButton(
    //                         onPressed: buttonAddEnabled ? () => data.addItem(product) : null,
    //                         icon: Icons.add_circle,
    //                         color: buttonAddEnabled ? AppColors.primary : Colors.grey,
    //                         size: 12,
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         );
    //       },
    //     ),
    //   ),
    // );
  }
}
