import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/modules/cart/cart_controller.dart';
import 'package:pos_app/modules/common/app_bar.dart';
import 'package:pos_app/modules/product/model/product_model.dart';

class CartPage extends StatelessWidget {
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Keranjang'),
      body: Obx(() {
        final items = cartController.cartItems;

        if (items.isEmpty) {
          return const Center(child: Text('Keranjang Kosong.'));
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            if (items[index] == null ||
                items[index]?.product == null ||
                items[index]?.quantity == null) {
              return SizedBox();
            }
            Product product = items[index]!.product;
            int quantity = items[index]!.quantity;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: Image.network(
                  product.gambar ?? "",
                  width: 50,
                  height: 50,
                  errorBuilder: (c, e, s) => Icon(Icons.broken_image),
                ),
                title: Text(product.namaBrg),
                subtitle: Text(
                  'Harga: \$${product.hargaJual.toStringAsFixed(2)}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => cartController.removeFromCart(product),
                    ),
                    Text(quantity.toString()),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => cartController.addToCart(product),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // Handle checkout logic here
            },
            child: Text(
              'Checkout Rp${NumberFormat("#,##0", "id_ID").format(cartController.totalPrice.value)}',
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
        );
      }),
    );
  }
}
