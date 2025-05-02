import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/cart/cart_controller.dart';
import 'package:pos_app/modules/cart/view/cart_button.dart';
import 'package:pos_app/modules/product/model/product_model.dart';
import 'package:pos_app/modules/product/product_contoller.dart';

class TransactionPage extends StatelessWidget {
  final cartController = Get.find<CartController>();
  final productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Buat Transaksi',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [CartButton()],
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

                return ListView.builder(
                  itemCount: productController.filteredProducts.length,
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
    return Card(
      margin: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 8,
      shadowColor: Colors.black26,
      child: Container(
        // color: Colors.white,
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   colors: [Colors.blue.shade100, Colors.blue.shade300],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          leading: Image.network(
            product.imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Icon(Icons.broken_image),
          ),
          title: Text(
            product.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed:
                    quantity > 0 ? () => cartController.removeFromCart(product) : null,
                icon: Icon(
                  Icons.remove,
                  color: quantity > 0 ? Colors.blueAccent : Colors.grey,
                ),
              ),
              Text(
                quantity.toString(),
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
              IconButton(
                onPressed: () {
                  cartController.addToCart(product);
                  Get.snackbar(
                    'Added to Cart',
                    '${product.title} added',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: Duration(milliseconds: 1000),
                    backgroundColor: Colors.blueAccent,
                    colorText: Colors.white,
                  );
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
