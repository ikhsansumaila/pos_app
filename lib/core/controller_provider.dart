import 'package:get/get.dart';

// HERE IS THE LIST OF CONTROLLERS IF USING GENERATOR
// T findOrPut<T extends Object>() {
//   if (Get.isRegistered<T>()) return Get.find<T>();

//   if (T == AuthController) return Get.put(AuthController()) as T;
//   if (T == OrdersController) return Get.put(OrdersController()) as T;
//   if (T == TransactionController) return Get.put(TransactionController()) as T;
//   if (T == CheckoutController) return Get.put(CheckoutController()) as T;
//   if (T == CartController) return Get.put(CartController()) as T;
//   if (T == UserFormController) return Get.put(UserFormController()) as T;
//   if (T == UserController) return Get.put(UserController()) as T;
//   if (T == SyncController) return Get.put(SyncController()) as T;
//   if (T == TransactionQueueController) return Get.put(TransactionQueueController()) as T;
//   if (T == SyncQueueDetailController) return Get.put(SyncQueueDetailController()) as T;
//   if (T == UserQueueController) return Get.put(UserQueueController()) as T;
//   if (T == UserSyncController) return Get.put(UserSyncController()) as T;
//   if (T == ProductSyncController) return Get.put(ProductSyncController()) as T;

//   throw Exception('getOrPut: Type $T tidak dikenali. Tambahkan ke controller_provider.dart.');
// }

class ControllerProvider {
  static T findOrPut<T extends Object>(T instance) {
    if (Get.isRegistered<T>()) {
      print('[getOrPut] Found existing ${T.toString()}');
      return Get.find<T>();
    } else {
      print('[getOrPut] Registering new ${T.toString()}');
      return Get.put<T>(instance);
    }
  }
}
