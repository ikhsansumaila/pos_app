import 'package:get/get.dart';
import 'package:pos_app/modules/cart/model/cart_item_model.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/modules/transaction/common/models/transaction_create_model.dart';
import 'package:pos_app/modules/transaction/selling/data/repository/transaction_repository.dart';

class TransactionController extends GetxController {
  final TransactionRepository repository;

  TransactionController({required this.repository});

  var trxItems = <int, CartItemModel>{}.obs;
  var totalItems = 0.obs;
  var totalPrice = 0.obs;

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

  Future<bool> createTransaction(TransactionCreateModel transaction) async {
    return await repository.postTransaction(transaction);
  }
}
