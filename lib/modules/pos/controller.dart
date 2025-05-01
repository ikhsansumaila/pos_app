import 'package:get/get.dart';
import 'package:pos_app/modules/product/product_models.dart';

class POSController extends GetxController {
  var products =
      <Product>[
        Product(id: 1, name: 'Apple', price: 1.5, imageUrl: ""),
        Product(id: 2, name: 'Banana', price: 0.8, imageUrl: ""),
        Product(id: 3, name: 'Orange', price: 1.2, imageUrl: ""),
      ].obs;

  var cart = <Product>[].obs;

  void addToCart(Product product) {
    cart.add(product);
  }

  void removeFromCart(Product product) {
    cart.remove(product);
  }

  double get total => cart.fold(0, (sum, item) => sum + item.price);
}
