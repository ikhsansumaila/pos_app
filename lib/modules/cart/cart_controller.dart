import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pos_app/modules/cart/model/cart_item_model.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';

class CartController extends GetxController {
  late Box<CartItemModel> _cartBox;
  var cartItems = <int, CartItemModel>{}.obs;
  var totalItems = 0.obs;
  var totalPrice = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    await Hive.deleteBoxFromDisk('cartBox');

    // Open the Hive box for CartItemModel
    // _cartBox = await Hive.openBox('cartBox');

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
    // for (var cartItem in _cartBox.values) {
    //   cartItems[cartItem.product.idBrg] = cartItem;
    // }
  }

  // Save cart items to Hive
  void _saveCart() {
    for (var cartItem in cartItems.values) {
      log("save cart ${cartItem.toString()}");
      // _cartBox.put(cartItem.product.idBrg, cartItem);
    }
  }

  void addToCart(ProductModel product) {
    final productId = product.idBrg;

    if (cartItems.containsKey(productId)) {
      cartItems.update(productId, (item) => item.copyWith(quantity: item.quantity + 1));
    } else {
      cartItems[productId] = CartItemModel(product: product, quantity: 1);
    }
    _setTotalItems();
    _setTotalPrice();
    // _saveCart(); // Persist the cart to Hive

    update();
  }

  void removeFromCart(ProductModel product) {
    final productId = product.idBrg;

    if (!cartItems.containsKey(productId)) return;

    if (cartItems[productId]!.quantity > 1) {
      cartItems.update(productId, (item) => item.copyWith(quantity: item.quantity - 1));
    } else {
      cartItems.remove(productId);
    }

    _setTotalItems();
    _setTotalPrice();
    // _saveCart(); // Persist the cart to Hive

    update();
  }

  int getQuantity(int id) => cartItems[id]?.quantity ?? 0;

  List<CartItemModel> get items => cartItems.values.toList();

  _setTotalPrice() {
    totalPrice.value = cartItems.values.fold(0, (sum, item) => sum + item.product.hargaJual * item.quantity);
  }

  _setTotalItems() {
    totalItems.value = cartItems.values.fold(0, (sum, item) => sum + item.quantity);
  }
}
