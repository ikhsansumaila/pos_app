import 'package:hive/hive.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

part 'cart_item_model.g.dart'; // The generated adapter file

@HiveType(typeId: HiveTypeIds.cartItem)
class CartItemModel {
  @HiveField(0)
  final ProductModel product;

  @HiveField(1)
  int quantity;

  CartItemModel({required this.product, this.quantity = 1});
  CartItemModel copyWith({ProductModel? product, int? quantity}) {
    return CartItemModel(product: product ?? this.product, quantity: quantity ?? this.quantity);
  }

  @override
  String toString() {
    return 'CartItemModel(product: $product, quantity: $quantity)';
  }
}
