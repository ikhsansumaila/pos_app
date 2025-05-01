import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/cart/cart_controller.dart';

class CartButton extends StatefulWidget {
  const CartButton({Key? key}) : super(key: key);

  @override
  CartButtonState createState() => CartButtonState();
}

class CartButtonState extends State<CartButton>
    with SingleTickerProviderStateMixin {
  final cartController = Get.find<CartController>();
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this, // This is the crucial part
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, 0),
    ).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Stack(
            children: [
              Icon(Icons.shopping_cart),
              if (cartController.cartItems.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${cartController.cartItems.length}',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          onPressed: () => Get.toNamed('/cart'),
        ),
        // Add the animated "fly to cart" icon
        Positioned(
          top: _animation.value.dy,
          left: _animation.value.dx,
          child: Icon(Icons.shopping_cart, size: 50, color: Colors.blue),
        ),
      ],
    );
  }

  // Method to trigger the animation when an item is added to the cart
  void animateToCart() {
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
