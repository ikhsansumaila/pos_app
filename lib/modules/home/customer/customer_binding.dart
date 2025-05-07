import 'package:get/get.dart';
import 'package:pos_app/modules/cart/cart_controller.dart';

class CustomerHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CartController());
  }
}
