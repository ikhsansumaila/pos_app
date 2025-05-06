import 'package:hive/hive.dart';
import 'package:pos_app/data/models/product_model.dart';

part 'cart_item_model.g.dart'; // The generated adapter file

@HiveType(typeId: 1)
class CartItemModel {
  @HiveField(0)
  final Product product;

  @HiveField(1)
  int quantity;

  CartItemModel({required this.product, this.quantity = 1});
  CartItemModel copyWith({Product? product, int? quantity}) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return 'CartItemModel(product: $product, quantity: $quantity)';
  }
}
