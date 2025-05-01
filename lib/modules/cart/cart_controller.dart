import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pos_app/modules/cart/model/cart_item_model.dart';
import 'package:pos_app/modules/product/model/product_model.dart';

class CartController extends GetxController {
  late Box<CartItemModel> _cartBox;
  var cartItems = <int, CartItemModel>{}.obs;

  @override
  void onInit() async {
    super.onInit();
    // Open the Hive box for CartItemModel
    _cartBox = await Hive.openBox<CartItemModel>('cartBox');

    // Load cart from Hive
    _loadCart();
  }

  @override
  void onClose() {
    super.onClose();
    // Close the Hive box when the controller is disposed
    _cartBox.close();
  }

  // Load cart items from Hive
  void _loadCart() {
    for (var cartItem in _cartBox.values) {
      cartItems[cartItem.product.id] = cartItem;
    }
  }

  // Save cart items to Hive
  void _saveCart() {
    for (var cartItem in cartItems.values) {
      log("save cart ${cartItem.toString()}");
      _cartBox.put(cartItem.product.id, cartItem);
    }
  }

  void addToCart(Product product) {
    final productId = product.id;

    if (cartItems.containsKey(productId)) {
      cartItems.update(
        productId,
        (item) => item.copyWith(quantity: item.quantity + 1),
      );
    } else {
      cartItems[productId] = CartItemModel(product: product, quantity: 1);
    }

    _saveCart(); // Persist the cart to Hive
  }

  void removeFromCart(Product product) {
    final productId = product.id;

    if (!cartItems.containsKey(productId)) return;

    if (cartItems[productId]!.quantity <= 1) {
      cartItems.remove(productId);
    } else {
      cartItems.update(
        productId,
        (item) => item.copyWith(quantity: item.quantity - 1),
      );
    }

    _saveCart(); // Persist the cart to Hive
  }

  int getQuantity(int id) => cartItems[id]?.quantity ?? 0;

  List<CartItemModel> get items => cartItems.values.toList();

  double get total => cartItems.values.fold(
    0,
    (sum, item) => sum + item.product.price * item.quantity,
  );
}
