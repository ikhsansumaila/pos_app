import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/cart/cart_controller.dart';
import 'package:pos_app/modules/cart/view/cart_button.dart';
import 'package:pos_app/modules/product/product_contoller.dart';

class ProductPage extends StatelessWidget {
  final cartController = Get.find<CartController>();
  final productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products'), actions: [CartButton()]),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: productController.searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (productController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemCount: productController.filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = productController.filteredProducts[index];

                  // final product = products[index];
                  final quantity = cartController.getQuantity(product.id);
                  log(quantity.toString());

                  return Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      leading: Image.network(
                        product.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Icon(Icons.broken_image),
                      ),
                      //Image.network(product.imageUrl, width: 50, height: 50),
                      title: Text(product.title),
                      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed:
                                quantity > 0
                                    ? () =>
                                        cartController.removeFromCart(product)
                                    : null,
                            icon: Icon(Icons.remove),
                          ),
                          Text(quantity.toString()),
                          IconButton(
                            onPressed: () {
                              cartController.addToCart(product);
                              Get.snackbar(
                                'Added to Cart',
                                '${product.title} added',
                                snackPosition: SnackPosition.BOTTOM,
                                duration: Duration(milliseconds: 1000),
                              );
                            },
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
