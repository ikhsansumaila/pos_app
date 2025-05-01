import 'package:get/get.dart';
import 'package:pos_app/modules/product/product_models.dart';

class CartController extends GetxController {
  final cartItems = <Product>[].obs;

  void addToCart(Product product) {
    cartItems.add(product);
  }

  void removeFromCart(Product product) {
    cartItems.remove(product);
  }

  void clearCart() {
    cartItems.clear();
  }

  double get total => cartItems.fold(0, (sum, item) => sum + item.price);
}
