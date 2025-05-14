import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/cart/cart_controller.dart';
import 'package:pos_app/modules/cart/model/cart_item_model.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/common/widgets/image.dart';
import 'package:pos_app/utils/formatter.dart';

class CartDetailPage extends StatefulWidget {
  const CartDetailPage({super.key});

  @override
  State<CartDetailPage> createState() => _CartDetailPageState();
}

class _CartDetailPageState extends State<CartDetailPage> {
  final cartController = Get.find<CartController>();

  late List<CartItemModel> cartItems;

  // int subTotal = 0;

  @override
  void initState() {
    super.initState();
    cartItems = Get.arguments as List<CartItemModel>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Detail Keranjang'),
      body:
          cartItems.isEmpty
              ? const Center(child: Text('Keranjang masih kosong.'))
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        var item = cartItems[index];
                        var product = item.product;
                        // var storeName = items.product.storeName;
                        var subtotal = item.quantity * (product.hargaJual ?? 0);
                        return ListTile(
                          leading: AppImage(
                            url: product.gambar,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(product.namaBrg ?? ''),
                          subtitle: Text(
                            '${AppFormatter.currency((product.hargaJual ?? 0).toDouble())} x ${item.quantity}',
                          ),
                          trailing: Text(
                            AppFormatter.currency(subtotal.toDouble()),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
