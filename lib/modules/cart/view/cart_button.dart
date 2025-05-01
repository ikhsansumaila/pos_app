import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/cart/cart_controller.dart';

class CartButton extends StatelessWidget {
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final count = cartController.cartItems.values.fold<int>(
        0,
        (prevValue, currentItem) => prevValue + currentItem.quantity,
      );

      return Stack(
        alignment: Alignment.topRight,
        children: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Get.toNamed('/cart'),
          ),
          if (count > 0)
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Text(
                  '$count',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      );
    });
  }
}
