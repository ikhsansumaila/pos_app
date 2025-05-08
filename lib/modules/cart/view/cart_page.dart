import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/modules/cart/cart_controller.dart';
import 'package:pos_app/modules/cart/model/cart_item_model.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/routes/routes.dart';
import 'package:pos_app/utils/constants/colors.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  final cartController = Get.find<CartController>();
  final currencyFormatter = NumberFormat("#,##0", "id_ID");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Keranjang'),
      body: GetBuilder(
        init: cartController,
        builder: (data) {
          final cartItems =
              data.cartItems; // Ganti dengan observasi GetX jika pakai Rx

          // Group items by store
          final Map<String, List<CartItemModel>> grouped = {};
          for (var item in cartItems.entries) {
            final cartItem = item.value;

            final key =
                '${cartItem.product.storeId}|${cartItem.product.storeName}';
            grouped.putIfAbsent(key, () => []).add(cartItem);
          }

          if (cartItems.isEmpty) {
            return const Center(child: Text('Keranjang masih kosong.'));
          }

          return Container(
            color: Colors.white,
            child: ListView(
              padding: const EdgeInsets.all(12),
              children:
                  grouped.entries.map((entry) {
                    final storeName = entry.key.split('|')[1];
                    final items = entry.value;
                    final subtotal = items.fold<int>(
                      0,
                      (sum, item) =>
                          sum + (item.quantity * item.product.hargaJual),
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap:
                              () => Get.toNamed(
                                AppRoutes.cartDetail.url,
                                arguments: items,
                              ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Toko : $storeName',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Total Item: ${items.length}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Subtotal: Rp${currencyFormatter.format(subtotal)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.priceColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  }).toList(),
            ),
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:pos_app/data/models/product_model.dart';
// import 'package:pos_app/modules/cart/cart_controller.dart';
// import 'package:pos_app/modules/common/app_bar.dart';
// import 'package:pos_app/modules/common/widgets/image.dart';

// class CartPage extends StatelessWidget {
//   final cartController = Get.find<CartController>();

//   CartPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: MyAppBar(title: 'Keranjang'),
//       body: Obx(() {
//         final items = cartController.cartItems;

//         if (items.isEmpty) {
//           return const Center(child: Text('Keranjang Kosong.'));
//         }

//         return ListView.builder(
//           itemCount: items.length,
//           itemBuilder: (context, index) {
//             if (items[index] == null ||
//                 items[index]?.product == null ||
//                 items[index]?.quantity == null) {
//               return SizedBox();
//             }
//             Product product = items[index]!.product;
//             int quantity = items[index]!.quantity;

//             return Card(
//               margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               child: ListTile(
//                 leading: AppImage(url: product.gambar),
//                 title: Text(product.namaBrg),
//                 subtitle: Text(
//                   'Harga: \$${product.hargaJual.toStringAsFixed(2)}',
//                 ),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.remove),
//                       onPressed: () => cartController.removeFromCart(product),
//                     ),
//                     Text(quantity.toString()),
//                     IconButton(
//                       icon: const Icon(Icons.add),
//                       onPressed: () => cartController.addToCart(product),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//       bottomNavigationBar: Obx(() {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: ElevatedButton(
//             onPressed: () {
//               // Handle checkout logic here
//             },
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               textStyle: const TextStyle(fontSize: 18),
//             ),
//             child: Text(
//               'Checkout Rp${NumberFormat("#,##0", "id_ID").format(cartController.totalPrice.value)}',
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
