import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pos_app/modules/auth/auth_controller.dart';
import 'package:pos_app/modules/cart/model/cart_item_model.dart';
import 'package:pos_app/modules/common/widgets/app_dialog.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/modules/transaction/common/models/transaction_create_model.dart';
import 'package:pos_app/modules/transaction/selling/data/repository/transaction_repository.dart';
import 'package:pos_app/utils/constants/constant.dart';

class TransactionController extends GetxController {
  final TransactionRepository repository;

  TransactionController({required this.repository});

  Box<CartItemModel>? _cartBox;
  var trxItems = <int, CartItemModel>{}.obs;
  var totalItems = 0.obs;
  var totalPrice = 0.obs;

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

  void addItem(ProductModel product) {
    final productId = product.idBrg;

    if (trxItems.containsKey(productId)) {
      trxItems.update(productId ?? 0, (item) => item.copyWith(quantity: item.quantity + 1));
    } else {
      // new item
      trxItems[productId ?? 0] = CartItemModel(product: product, quantity: 1);
    }

    _updateTotal();
    // _saveCart(); // Persist the cart to Hive
    update(); //rebuild getbuilder
  }

  void removeItem(ProductModel product) {
    final productId = product.idBrg;

    // if not contain item
    if (!trxItems.containsKey(productId)) return;

    if (trxItems[productId]!.quantity > 1) {
      trxItems.update(productId ?? 0, (item) => item.copyWith(quantity: item.quantity - 1));
    } else {
      //1 item left
      trxItems.remove(productId);
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
      (sum, item) => sum + (item.product.hargaJual ?? 0) * (item.quantity ?? 0),
    );
  }

  void _setTotalItems() {
    totalItems.value = trxItems.values.fold(0, (sum, item) => sum + item.quantity);
  }

  void clearItems() {
    trxItems.clear();
    _setTotalItems();
    _setTotalPrice();
  }

  Future<void> createTransaction(double totalHarga) async {
    AuthController authController = Get.find<AuthController>();
    var userLoginData = authController.getUserLoginData();
    if (userLoginData == null) {
      await authController.forceLogout();
      return;
    }
    if (userLoginData.role == AppUserRole.cashier && userLoginData.storeId == null) {
      await AppDialog.show(
        'Terjadi kesalahan',
        content: 'User tidak terdaftar di toko, silakan login dengan akun lain',
      );
      return;
    }

    // Proses pembayaran
    var transType = 'OUT';
    var transDate = DateTime.now().toIso8601String();
    var description = '';
    var transSubtotal = totalHarga;
    var transDiscount = 0.0;
    var transTotal = totalHarga;
    var transPayment = totalHarga;
    var transBalance = 0.0;
    var userId = userLoginData.id;
    var storeId = userLoginData.storeId!;

    var trxItems =
        items.map((item) {
          var subTotal = (item.product.hargaJual ?? 0).toDouble() * item.quantity;
          return TransactionItemModel(
            idBarang: item.product.idBrg ?? 0,
            kodeBarang: item.product.kodeBrg ?? '',
            description: description,
            qty: item.quantity,
            price: (item.product.hargaJual ?? 0).toDouble(),
            subtotal: subTotal,
            discount: 0.0,
            total: subTotal,
          );
        }).toList();

    var trxData = TransactionCreateModel(
      cacheId: repository.generateNextCacheId(),
      storeId: storeId,
      transType: transType,
      transDate: transDate,
      description: description,
      transSubtotal: transSubtotal,
      transDiscount: transDiscount,
      transTotal: transTotal,
      transPayment: transPayment,
      transBalance: transBalance,
      userId: userId,
      items: trxItems,
    );
    await repository.postTransaction(trxData);
  }
}
