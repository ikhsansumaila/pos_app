import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/modules/cart/cart_controller.dart';
import 'package:pos_app/modules/cart/model/cart_item_model.dart';
import 'package:pos_app/modules/common/app_bar.dart';
import 'package:pos_app/modules/common/widgets/image.dart';

class CartDetailPage extends StatefulWidget {
  CartDetailPage({super.key});

  @override
  State<CartDetailPage> createState() => _CartDetailPageState();
}

class _CartDetailPageState extends State<CartDetailPage> {
  final cartController = Get.find<CartController>();

  final currencyFormatter = NumberFormat("#,##0", "id_ID");

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
                        var subtotal = item.quantity * product.hargaJual;
                        return ListTile(
                          leading: AppImage(
                            url: product.gambar,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(product.namaBrg),
                          subtitle: Text(
                            'Rp${currencyFormatter.format(product.hargaJual)} x ${item.quantity}',
                          ),
                          trailing: Text(
                            'Rp${currencyFormatter.format(product.hargaJual * item.quantity)}',
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
