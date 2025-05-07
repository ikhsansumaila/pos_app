import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pos_app/data/models/product_model.dart';
import 'package:pos_app/modules/cart/model/cart_item_model.dart';

class TransactionController extends GetxController {
  Box<CartItemModel>? _cartBox;
  var trxItems = <int, CartItemModel>{}.obs;
  var totalItems = 0.obs;
  var totalPrice = 0.obs;
  // var isUpdate = false.obs;

  // @override
  // void onInit() async {
  //   super.onInit();
  //   // await Hive.deleteBoxFromDisk('cartBox');

  //   // Open the Hive box for CartItemModel
  //   // _cartBox = await Hive.openBox<CartItemModel>('cartBox');

  //   // Load cart from Hive
  //   // _loadCart();
  // }

  @override
  void onClose() {
    super.onClose();
    // Close the Hive box when the controller is disposed
    _cartBox?.close();
  }

  // Load cart items from Hive
  // void _loadCart() {
  //   for (var cartItem in _cartBox?.values) {
  //     cartItems[cartItem.product.idBrg] = cartItem;
  //   }
  // }

  // Save cart items to Hive
  // void _saveCart() {
  //   for (var cartItem in cartItems.values) {
  //     log("save cart ${cartItem.toString()}");
  //     _cartBox?.put(cartItem.product.idBrg, cartItem);
  //   }
  // }

  void addItem(Product product) {
    if (trxItems.containsKey(product.idBrg)) {
      trxItems.update(
        product.idBrg,
        (item) => item.copyWith(quantity: item.quantity + 1),
      );
    } else {
      // new item
      trxItems[product.idBrg] = CartItemModel(product: product, quantity: 1);
    }

    _updateTotal();
    // _saveCart(); // Persist the cart to Hive
    update(); //rebuild getbuilder
  }

  void removeItem(Product product) {
    // if not contain item
    if (!trxItems.containsKey(product.idBrg)) return;

    if (trxItems[product.idBrg]!.quantity > 1) {
      trxItems.update(
        product.idBrg,
        (item) => item.copyWith(quantity: item.quantity - 1),
      );
    } else {
      //1 item left
      trxItems.remove(product.idBrg);
    }

    _updateTotal();
    // _saveCart(); // Persist the cart to Hive
    update(); //rebuild getbuilder
  }

  int getQuantity(int id) => trxItems[id]?.quantity ?? 0;

  List<CartItemModel> get items => trxItems.values.toList();

  void _updateTotal() {
    _setTotalPrice();
    _setTotalItems();
  }

  void _setTotalPrice() {
    totalPrice.value = trxItems.values.fold(
      0,
      (sum, item) => sum + item.product.hargaJual * item.quantity,
    );
  }

  void _setTotalItems() {
    totalItems.value = trxItems.values.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
  }

  void clearItems() {
    trxItems.clear();
    _setTotalItems();
    _setTotalPrice();
  }
}
