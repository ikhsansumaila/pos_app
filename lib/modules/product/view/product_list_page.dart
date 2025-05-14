import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/common/widgets/image.dart';
import 'package:pos_app/modules/common/widgets/search_bar_widget.dart';
import 'package:pos_app/modules/product/controller/product_contoller.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/modules/product/view/product_detail_page.dart';
import 'package:pos_app/routes/routes.dart';
import 'package:pos_app/utils/constants/colors.dart';
import 'package:pos_app/utils/formatter.dart';
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
      ),
    );
  }

  Widget _buildProductCard(ProductModel product, ResponsiveHelper responsive) {
    double circularRadius = 10;
    int stock = product.stok ?? 0;

    int maxLines = 3;
    double fontSize = 20;
    double lineHeight = 1.2;
    double imageHeight = 150;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(circularRadius)),
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
                    product.namaBrg ?? '',
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
                  AppFormatter.currency((product.hargaJual ?? 0).toDouble()),
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
