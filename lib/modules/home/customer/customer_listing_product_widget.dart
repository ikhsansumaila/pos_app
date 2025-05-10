import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/cart/cart_controller.dart';
import 'package:pos_app/modules/common/widgets/icon_button.dart';
import 'package:pos_app/modules/common/widgets/image.dart';
import 'package:pos_app/modules/common/widgets/search_bar_widget.dart';
import 'package:pos_app/modules/product/controller/product_contoller.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/modules/product/view/product_detail_page.dart';
import 'package:pos_app/utils/constants/colors.dart';
import 'package:pos_app/utils/formatter.dart';
import 'package:pos_app/utils/responsive_helper.dart';

class CustomerListing extends StatelessWidget {
  CustomerListing({super.key});

  final cartController = Get.find<CartController>();
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
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: GridView.builder(
                      itemCount: productController.filteredProducts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 0.1,
                        mainAxisSpacing: 0.1,
                        childAspectRatio: 0.8,
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
      ],
    );
  }

  Widget _buildProductCard(Product product, ResponsiveHelper responsive) {
    double circularRadius = 14;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularRadius),
        ),
        elevation: 8,
        shadowColor: Colors.black26,
        child: GetBuilder(
          init: cartController,
          builder: (data) {
            final quantity = data.getQuantity(product.idBrg);
            int stock = product.stok;

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
                      product.namaBrg,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      AppFormatter.currency(product.hargaJual.toDouble()),
                      style: TextStyle(
                        color: AppColors.priceColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '(Stok: $stock)',
                          style: TextStyle(color: Colors.black87, fontSize: 10),
                        ),
                        Row(
                          children: [
                            AppIconButton(
                              onPressed:
                                  buttonRemoveEnabled
                                      ? () => data.removeFromCart(product)
                                      : null,
                              icon: Icons.remove_circle,
                              color:
                                  buttonRemoveEnabled
                                      ? Colors.red
                                      : Colors.grey,
                              size: 14,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              quantity.toString(),
                              style: TextStyle(
                                fontSize: 10,
                                color:
                                    stock == 0 ? Colors.grey : Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            AppIconButton(
                              onPressed:
                                  buttonAddEnabled
                                      ? () => data.addToCart(product)
                                      : null,
                              icon: Icons.add_circle,
                              color:
                                  buttonAddEnabled
                                      ? AppColors.primary
                                      : Colors.grey,
                              size: 14,
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
  }
}
