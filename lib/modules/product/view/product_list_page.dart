import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/modules/common/app_bar.dart';
import 'package:pos_app/modules/common/widgets/image.dart';
import 'package:pos_app/modules/product/model/product_model.dart';
import 'package:pos_app/modules/product/product_contoller.dart';
import 'package:pos_app/routes.dart';
import 'package:pos_app/utils/constants/colors.dart';

class ProductPage extends StatelessWidget {
  final productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
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
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 2, // Aspect ratio for card size
                    ),
                    itemBuilder: (context, index) {
                      final product = productController.filteredProducts[index];
                      return _buildProductCard(product);
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

  Widget _buildProductCard(Product product) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardHeight = 280.0; // You can tweak this height as needed
        final imageHeight = cardHeight * 0.7;

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 6,
          child: Container(
            height: cardHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 39, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: imageHeight,
                    width: double.infinity,
                    child: AppImage(url: product.gambar, fit: BoxFit.contain),

                    // Image.network(
                    //   product.gambar ?? "https://loremflickr.com/320/240",
                    //   fit: BoxFit.contain,
                    //   errorBuilder:
                    //       (context, error, stackTrace) => Container(
                    //         color: Colors.grey.shade200,
                    //         child: Icon(
                    //           Icons.broken_image,
                    //           size: 40,
                    //           color: Colors.grey,
                    //         ),
                    //       ),
                    // ),
                  ),
                ),
                SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          product.namaBrg,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),

                        // Price
                        Text(
                          'Rp${NumberFormat("#,##0", "id_ID").format(product.hargaJual)}',
                          style: TextStyle(
                            color: AppColors.priceColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // Price
                    Text(
                      'Stok : 100',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
