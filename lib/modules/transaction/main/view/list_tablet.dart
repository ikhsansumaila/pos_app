import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/modules/common/widgets/image.dart';
import 'package:pos_app/modules/common/widgets/search_bar_widget.dart';
import 'package:pos_app/modules/product/controller/product_contoller.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/modules/transaction/main/transaction_controller.dart';
import 'package:pos_app/modules/transaction/main/view/transaction_button.dart';
import 'package:pos_app/routes/routes.dart';
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

  Widget _buildProductCard(Product product) {
    double imageSize = 100;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 8,
      shadowColor: Colors.black26,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: AppImage(
                  url: product.gambar,
                  height: imageSize,
                  width: imageSize,
                  fit: BoxFit.contain,
                ),
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
                    int stock = product.stok;

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
                                        AppRoutes.stockMutation.url,
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
            ],
          ),
        ),
      ),
    );
  }
}
