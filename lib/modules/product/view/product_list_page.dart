import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/modules/common/app_bar.dart';
import 'package:pos_app/modules/common/widgets/image.dart';
import 'package:pos_app/modules/product/model/product_model.dart';
import 'package:pos_app/modules/product/product_contoller.dart';
import 'package:pos_app/routes.dart';
import 'package:pos_app/utils/constants/colors.dart';
import 'package:pos_app/utils/responsive_helper.dart';

class ProductPage extends StatelessWidget {
  final productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(MediaQuery.of(context).size);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Get.toNamed(AppRoutes.addProduct),
      ),
      appBar: MyAppBar(
        title: 'List Barang',
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert), // Icon untuk menu
            onPressed: () => {}, //_showMenuBottomSheet(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.primaryGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: _buildSearchBar(),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                    itemCount: productController.filteredProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two columns per row
                      crossAxisSpacing: 0.1,
                      mainAxisSpacing: 0.1,
                      childAspectRatio: 1.7,
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
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white.withOpacity(0.9),
      ),
      child: TextField(
        controller: productController.searchController,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Cari Barang...',
          hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 16),
          prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
          // suffixIcon: BarcodeScanner(),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product, ResponsiveHelper responsive) {
    double circularRadius = 14;
    int stock = 100;

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
        child: Padding(
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
                          style: TextStyle(color: Colors.black87, fontSize: 8),
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
                          color: stock == 0 ? Colors.grey : AppColors.primary,
                          size: 12,
                        ),
                        const SizedBox(width: 2), // spasi minimal
                        Text(
                          'Pecah Stok',
                          style: TextStyle(
                            color: stock == 0 ? Colors.grey : AppColors.primary,
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Tombol + / - dan qty
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     AppIconButton(
                  //       onPressed:
                  //           buttonRemoveEnabled
                  //               ? () => data.removeItem(product)
                  //               : null,
                  //       icon: Icons.remove_circle,
                  //       color:
                  //           buttonRemoveEnabled ? Colors.red : Colors.grey,
                  //       size: 12,
                  //     ),
                  //     const SizedBox(width: 8),
                  //     Text(
                  //       quantity.toString(),
                  //       style: TextStyle(
                  //         fontSize: 8,
                  //         color: stock == 0 ? Colors.grey : Colors.black87,
                  //       ),
                  //     ),
                  //     const SizedBox(width: 8),
                  //     AppIconButton(
                  //       onPressed:
                  //           buttonAddEnabled
                  //               ? () => data.addItem(product)
                  //               : null,
                  //       icon: Icons.add_circle,
                  //       color:
                  //           buttonAddEnabled
                  //               ? AppColors.primary
                  //               : Colors.grey,
                  //       size: 12,
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ],
          ),
        ),

        // GetBuilder(
        //   init: trxController,
        //   builder: (data) {
        //     final quantity = data.getQuantity(product.idBrg);
        //     int stock = 10;

        //     bool buttonAddEnabled = stock > 0 && quantity < stock;
        //     bool buttonRemoveEnabled = stock > 0 && quantity > 0;
        //     return Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           // ROW: Gambar dan informasi
        //           Row(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               AppImage(url: product.gambar, width: 40, height: 40),
        //               const SizedBox(width: 8),
        //               Expanded(
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Text(
        //                       product.namaBrg,
        //                       style: TextStyle(
        //                         fontWeight: FontWeight.bold,
        //                         fontSize: 8,
        //                         color: Colors.black87,
        //                       ),
        //                     ),
        //                     Text(
        //                       'Rp${NumberFormat("#,##0", "id_ID").format(product.hargaJual)}',
        //                       style: TextStyle(
        //                         color: AppColors.priceColor,
        //                         fontSize: 10,
        //                         fontWeight: FontWeight.bold,
        //                       ),
        //                     ),
        //                     Text(
        //                       '(Stok: $stock)',
        //                       style: TextStyle(
        //                         color: Colors.black87,
        //                         fontSize: 8,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ],
        //           ),
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               InkWell(
        //                 onTap:
        //                     stock == 0
        //                         ? null
        //                         : () {
        //                           Get.toNamed(
        //                             AppRoutes.stockMutation,
        //                             arguments: product,
        //                           );
        //                         },
        //                 child: Row(
        //                   mainAxisSize: MainAxisSize.min,
        //                   children: [
        //                     Icon(
        //                       Icons.call_split,
        //                       color:
        //                           stock == 0 ? Colors.grey : AppColors.primary,
        //                       size: 12,
        //                     ),
        //                     const SizedBox(width: 2), // spasi minimal
        //                     Text(
        //                       'Pecah Stok',
        //                       style: TextStyle(
        //                         color:
        //                             stock == 0
        //                                 ? Colors.grey
        //                                 : AppColors.primary,
        //                         fontSize: 8,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //               // Tombol + / - dan qty
        //               // Row(
        //               //   mainAxisAlignment: MainAxisAlignment.start,
        //               //   children: [
        //               //     AppIconButton(
        //               //       onPressed:
        //               //           buttonRemoveEnabled
        //               //               ? () => data.removeItem(product)
        //               //               : null,
        //               //       icon: Icons.remove_circle,
        //               //       color:
        //               //           buttonRemoveEnabled ? Colors.red : Colors.grey,
        //               //       size: 12,
        //               //     ),
        //               //     const SizedBox(width: 8),
        //               //     Text(
        //               //       quantity.toString(),
        //               //       style: TextStyle(
        //               //         fontSize: 8,
        //               //         color: stock == 0 ? Colors.grey : Colors.black87,
        //               //       ),
        //               //     ),
        //               //     const SizedBox(width: 8),
        //               //     AppIconButton(
        //               //       onPressed:
        //               //           buttonAddEnabled
        //               //               ? () => data.addItem(product)
        //               //               : null,
        //               //       icon: Icons.add_circle,
        //               //       color:
        //               //           buttonAddEnabled
        //               //               ? AppColors.primary
        //               //               : Colors.grey,
        //               //       size: 12,
        //               //     ),
        //               //   ],
        //               // ),
        //             ],
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }
  // Widget _buildProductCard(Product product) {
  //   return LayoutBuilder(
  //     builder: (context, constraints) {
  //       final cardHeight = 280.0; // You can tweak this height as needed
  //       final imageHeight = cardHeight * 0.7;

  //       return Card(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         elevation: 6,
  //         child: Container(
  //           height: cardHeight,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(20),
  //             color: Colors.white,
  //           ),
  //           padding: const EdgeInsets.symmetric(horizontal: 39, vertical: 12),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // Product Image
  //               ClipRRect(
  //                 borderRadius: BorderRadius.circular(12),
  //                 child: Container(
  //                   height: imageHeight,
  //                   width: double.infinity,
  //                   child: AppImage(url: product.gambar, fit: BoxFit.contain),

  //                   // Image.network(
  //                   //   product.gambar ?? "https://loremflickr.com/320/240",
  //                   //   fit: BoxFit.contain,
  //                   //   errorBuilder:
  //                   //       (context, error, stackTrace) => Container(
  //                   //         color: Colors.grey.shade200,
  //                   //         child: Icon(
  //                   //           Icons.broken_image,
  //                   //           size: 40,
  //                   //           color: Colors.grey,
  //                   //         ),
  //                   //       ),
  //                   // ),
  //                 ),
  //               ),
  //               SizedBox(height: 15),

  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 crossAxisAlignment: CrossAxisAlignment.end,
  //                 children: [
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       // Title
  //                       Text(
  //                         product.namaBrg,
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 16,
  //                           color: Colors.black87,
  //                         ),
  //                         maxLines: 2,
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                       SizedBox(height: 4),

  //                       // Price
  //                       Text(
  //                         'Rp${NumberFormat("#,##0", "id_ID").format(product.hargaJual)}',
  //                         style: TextStyle(
  //                           color: AppColors.priceColor,
  //                           fontSize: 22,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                     ],
  //                   ),

  //                   // Price
  //                   Text(
  //                     'Stok : 100',
  //                     style: TextStyle(color: Colors.blueGrey, fontSize: 20),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void _showMenuBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled:
      //     true, // Allows you to control the height of the BottomSheet
      builder: (context) {
        return Container(
          width: double.infinity, // Make the container full width
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Tambah Barang'),
                onTap: () => Get.toNamed(AppRoutes.addProduct),
              ),
            ],
          ),
        );
      },
    );
  }
}
