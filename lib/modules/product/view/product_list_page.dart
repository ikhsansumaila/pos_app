import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/common/widgets/image.dart';
import 'package:pos_app/modules/common/widgets/search_bar_widget.dart';
import 'package:pos_app/modules/product/controller/product_contoller.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/modules/product/view/product_detail_page.dart';
import 'package:pos_app/routes/routes.dart';
import 'package:pos_app/utils/constants/colors.dart';
import 'package:pos_app/utils/responsive_helper.dart';

class ProductPage extends StatelessWidget {
  final productController = Get.find<ProductController>();

  ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(MediaQuery.of(context).size);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => Get.toNamed(AppRoutes.addProduct.url),
        ),
        appBar: MyAppBar(
          title: 'List Barang',
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.more_vert), // Icon untuk menu
          //     onPressed: () => {}, //_showMenuBottomSheet(context),
          //   ),
          // ],
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
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: AppSearchBar(
                        controller: productController.searchController,
                        hintText: 'Cari Barang...',
                      ),
                    ),
                  ],
                ),
              ),

              // Listing Product
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      itemCount: productController.filteredProducts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: responsive.isLandscape ? 4 : 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: responsive.isLandscape ? 0.7 : 0.7,
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
      ),
    );
  }

  Widget _buildProductCard(Product product, ResponsiveHelper responsive) {
    double circularRadius = 10;
    int stock = product.stok;

    int maxLines = 3;
    double fontSize = 20;
    double lineHeight = 1.2;
    double imageHeight = 150;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularRadius),
        ),
        elevation: 8,
        shadowColor: Colors.black26,
        child: GestureDetector(
          onTap: () {
            Get.to(() => ProductDetailPage(product: product));
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  child: AppImage(
                    url: product.gambar,
                    width: double.infinity, // Ini penting agar penuh
                    height: responsive.getProductImageSize(imageHeight),
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: fontSize * lineHeight * maxLines,
                  child: Text(
                    product.namaBrg,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.fontSize(fontSize) - 2,
                      color: Colors.black87,
                      height: lineHeight,
                    ),
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Rp${NumberFormat("#,##0", "id_ID").format(product.hargaJual)}',
                  style: TextStyle(
                    color: AppColors.priceColor,
                    fontSize: responsive.fontSize(fontSize),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '(Stok: $stock)',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: responsive.fontSize(fontSize) - 4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:pos_app/modules/common/widgets/image.dart';
// import 'package:pos_app/modules/product/data/models/product_model.dart';
// import 'package:pos_app/utils/constants/colors.dart';
// import 'package:pos_app/utils/responsive_helper.dart';

// // Dummy product untuk preview
// final product = Product(
//   idBrg: 1,
//   namaBrg: "Smartphone",
//   hargaJual: 5000000,
//   gambar:
//       "https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
//   stok: 10,
//   userid: 1,
//   storeId: 1,
//   storeName: "Store A",
//   createdAt: DateTime.now().toIso8601String(),
//   status: "active",
//   margin: 0,
//   satuan: "pcs",
//   hargaBeli: 0,
//   kodeBrg: "SPH-001",
// );

// class ProductPage extends StatelessWidget {
//   const ProductPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final responsive = ResponsiveHelper(MediaQuery.of(context).size);

//     return Scaffold(
//       appBar: AppBar(title: Text("Product Card Preview - $size")),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: GridView.builder(
//           itemCount: 20,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: responsive.getProductCardListCount(),
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//             childAspectRatio: responsive.getProductCardAspectRatio(),
//           ),
//           itemBuilder: (context, index) {
//             // return _buildProductCard(product, responsive);
//             // if (index < 6) {
//             log(
//               "responsive.isTablet ${responsive.isTablet}, screenSize.shortestSide ${size.shortestSide}",
//             );
//             if (responsive.isTablet) {
//               if (responsive.isLandscape) {
//                 product.namaBrg = "Tablet (Landscape)";
//                 return _buildProductCard(product, responsive);
//                 // return _previewSection(
//                 //   "Tablet (Landscape)",
//                 //   const Size(1280, 800),
//                 // );
//               }
//               product.namaBrg = "Tablet (Portrait)";
//               return _buildProductCard(product, responsive);
//               // return _previewSection(
//               //   "Tablet (Portrait)",
//               //   const Size(1280, 800),
//               // );
//             }
//             return _buildProductCard(product, responsive);
//             // if (responsive.isLandscape) {
//             //   return _previewSection(
//             //     "Smartphone (Landscape)",
//             //     const Size(360, 640),
//             //   );
//             // }
//             // return _previewSection(
//             //   "Smartphone (Portrait)",
//             //   const Size(360, 640),
//             // );
//           },
//         ),
//       ),

//       // ListView(
//       //   padding: const EdgeInsets.all(16),
//       //   children:

//       // [
//       //   _previewSection("Smartphone (Portrait)", const Size(360, 640)),
//       //   _previewSection("Tablet (Portrait)", const Size(800, 1280)),
//       //   _previewSection("Tablet (Landscape)", const Size(1280, 800)),
//       // ],
//       // ),
//     );
//   }

  // Widget _previewSection(String title, Size size) {
  //   product.namaBrg = title;
  //   return _buildProductCard(product, responsive);
  // }

  // Widget _buildProductCard(Product product, ResponsiveHelper responsive) {
  //   double circularRadius = 20;
  //   int stock = product.stok;

  //   int maxLines = 3;
  //   double fontSize = 20;
  //   double lineHeight = 1.2;
  //   double imageHeight = 150;

  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 8.0),
  //     child: Card(
  //       margin: EdgeInsets.symmetric(horizontal: 5),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(circularRadius),
  //       ),
  //       elevation: 8,
  //       shadowColor: Colors.black26,
  //       child: GestureDetector(
  //         onTap: () {
  //           // Get.to(() => ProductDetailPage(product: product));
  //         },
  //         child: Padding(
  //           padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               ClipRRect(
  //                 child: AppImage(
  //                   url: product.gambar,
  //                   width: double.infinity, // Ini penting agar penuh
  //                   height: responsive.imageSize(imageHeight),
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //               const SizedBox(height: 15),
  //               SizedBox(
  //                 height: fontSize * lineHeight * maxLines,
  //                 child: Text(
  //                   product.namaBrg,
  //                   style: TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: responsive.fontSize(fontSize) - 2,
  //                     color: Colors.black87,
  //                     height: lineHeight,
  //                   ),
  //                   maxLines: maxLines,
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //               ),
  //               SizedBox(height: 10),
  //               Text(
  //                 'Rp${NumberFormat("#,##0", "id_ID").format(product.hargaJual)}',
  //                 style: TextStyle(
  //                   color: AppColors.priceColor,
  //                   fontSize: responsive.fontSize(fontSize),
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     '(Stok: $stock)',
  //                     style: TextStyle(
  //                       color: Colors.black87,
  //                       fontSize: responsive.fontSize(fontSize) - 4,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
// }
