import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/cart/cart_controller.dart';
import 'package:pos_app/modules/cart/view/cart_button.dart';
import 'package:pos_app/modules/product/model/product_model.dart';
import 'package:pos_app/modules/product/product_contoller.dart';

class ProductPage extends StatelessWidget {
  final cartController = Get.find<CartController>();
  final productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
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

                return GridView.builder(
                  itemCount: productController.filteredProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two columns per row
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 2, // Aspect ratio for card size
                  ),
                  itemBuilder: (context, index) {
                    final product = productController.filteredProducts[index];
                    final quantity = cartController.getQuantity(product.id);
                    log(quantity.toString());

                    return _buildProductCard(product, quantity);
                  },
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
          hintText: 'Search products...',
          hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 16),
          prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product, int quantity) {
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
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            color: Colors.grey.shade200,
                            child: Icon(
                              Icons.broken_image,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                    ),
                  ),
                ),
                SizedBox(height: 5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          product.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),

                        // Price
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.orange[400],
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),

                    // Price
                    Text(
                      'Stok : 100',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 25),
                    ),
                  ],
                ),

                Spacer(),

                // Quantity control
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Row(
                //       children: [
                //         IconButton(
                //           onPressed: quantity > 0
                //               ? () => cartController.removeFromCart(product)
                //               : null,
                //           icon:
                //               Icon(Icons.remove_circle, color: Colors.redAccent),
                //         ),
                //         Text(
                //           quantity.toString(),
                //           style: TextStyle(
                //               fontSize: 16, fontWeight: FontWeight.w500),
                //         ),
                //         IconButton(
                //           onPressed: () {
                //             cartController.addToCart(product);
                //             Get.snackbar(
                //               'Added to Cart',
                //               '${product.title} added',
                //               snackPosition: SnackPosition.BOTTOM,
                //               duration: Duration(milliseconds: 800),
                //             );
                //           },
                //           icon: Icon(Icons.add_circle, color: Colors.green),
                //         ),
                //       ],
                //     ),
                //     Icon(Icons.shopping_cart_outlined,
                //         color: Colors.blueAccent),
                //   ],
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
