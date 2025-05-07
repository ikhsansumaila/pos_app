import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/data/models/product_model.dart';
import 'package:pos_app/modules/common/app_bar.dart';
import 'package:pos_app/modules/common/widgets/image.dart';
import 'package:pos_app/modules/common/widgets/product_list_card.dart';
import 'package:pos_app/modules/product/product_contoller.dart';
import 'package:pos_app/routes.dart';
import 'package:pos_app/utils/constants/colors.dart';
import 'package:pos_app/utils/responsive_helper.dart';

class ProductPage extends StatelessWidget {
  final productController = Get.find<ProductController>();

  ProductPage({super.key});

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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                    itemCount: productController.filteredProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two columns per row
                      crossAxisSpacing: 0.1,
                      mainAxisSpacing: 0.1,
                      childAspectRatio: responsive.childAspectRatio,
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

  Widget _buildSearchBar(ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white.withValues(alpha: 0.9),
      ),
      child: TextField(
        controller: productController.searchController,
        style: TextStyle(
          color: Colors.black,
          fontSize: responsive.fontSize(20),
        ),
        decoration: InputDecoration(
          hintText: 'Cari Barang...',
          hintStyle: TextStyle(
            color: Colors.blueGrey,
            fontSize: responsive.fontSize(20),
          ),
          prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
          // suffixIcon: BarcodeScanner(),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product, ResponsiveHelper responsive) {
    int stock = 100;
    double imageSize = responsive.imageSize(100);

    return ProductListCard(
      product: product,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ROW: Gambar dan informasi
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppImage(
                url: product.gambar,
                width: imageSize,
                height: imageSize,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.namaBrg,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.fontSize(16),
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Rp${NumberFormat("#,##0", "id_ID").format(product.hargaJual)}',
                      style: TextStyle(
                        color: AppColors.priceColor,
                        fontSize: responsive.fontSize(18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '(Stok: $stock)',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: responsive.fontSize(16),
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
                      color: stock == 0 ? Colors.grey : AppColors.primary,
                      size: responsive.fontSize(16),
                    ),
                    const SizedBox(width: 2), // spasi minimal
                    Text(
                      'Pecah Stok',
                      style: TextStyle(
                        color: stock == 0 ? Colors.grey : AppColors.primary,
                        fontSize: responsive.fontSize(16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
