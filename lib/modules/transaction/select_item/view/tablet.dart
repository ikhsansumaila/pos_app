import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/data/models/product_model.dart';
import 'package:pos_app/modules/common/widgets/image.dart';
import 'package:pos_app/modules/product/product_contoller.dart';
import 'package:pos_app/modules/transaction/select_item/transaction_controller.dart';
import 'package:pos_app/modules/transaction/select_item/view/transaction_button.dart';
import 'package:pos_app/routes.dart';
import 'package:pos_app/utils/constants/colors.dart';

class TabletLayout extends StatelessWidget {
  TabletLayout({super.key});
  final trxController = Get.find<TransactionController>();
  final productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: ListView.builder(
                      itemCount: productController.filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product =
                            productController.filteredProducts[index];
                        return _buildProductCard(product);
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
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 8,
      shadowColor: Colors.black26,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: AppImage(url: product.gambar),
                title: Text(
                  product.namaBrg,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  'Rp${NumberFormat("#,##0", "id_ID").format(product.hargaJual)}',
                  style: TextStyle(
                    color: AppColors.priceColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: GetBuilder(
                  init: trxController,
                  builder: (data) {
                    final quantity = data.getQuantity(product.idBrg);
                    int stock = 10;

                    bool buttonAddEnabled = stock > 0 && quantity < stock;
                    bool buttonRemoveEnabled = stock > 0 && quantity > 0;

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed:
                                stock == 0
                                    ? null
                                    : () {
                                      Get.toNamed(
                                        AppRoutes.stockMutation,
                                        arguments: product,
                                      );
                                    },
                            icon: Icon(
                              Icons.call_split,
                              color:
                                  stock == 0 ? Colors.grey : AppColors.primary,
                            ),
                            label: Text(
                              'Pecah Stok',
                              style: TextStyle(
                                color:
                                    stock == 0
                                        ? Colors.grey
                                        : AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '(Stok: $stock)',
                          style: TextStyle(color: Colors.black87, fontSize: 16),
                        ),
                        SizedBox(width: 12),

                        // REMOVE BUTTON
                        IconButton(
                          onPressed:
                              buttonRemoveEnabled
                                  ? () => data.removeItem(product)
                                  : null,
                          icon: Icon(
                            Icons.remove_circle,
                            color:
                                buttonRemoveEnabled ? Colors.red : Colors.grey,
                          ),
                        ),

                        // QUANTITY
                        Text(
                          quantity.toString(),
                          style: TextStyle(
                            color: stock == 0 ? Colors.grey : Colors.black87,
                            fontSize: 16,
                          ),
                        ),

                        // ADD BUTTON
                        IconButton(
                          onPressed:
                              buttonAddEnabled
                                  ? () => data.addItem(product)
                                  : null,
                          icon: Icon(
                            Icons.add_circle,
                            color:
                                buttonAddEnabled
                                    ? AppColors.primary
                                    : Colors.grey,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Tombol Pecah Stok
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: TextButton.icon(
              //     onPressed: () {
              //       Get.toNamed('/pecah-stok', arguments: product);
              //     },
              //     icon: Icon(Icons.call_split, color: AppColors.primary),
              //     label: Text(
              //       'Pecah Stok',
              //       style: TextStyle(color: AppColors.primary),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
