import 'package:hive/hive.dart';

part './order_model.g.dart';

@HiveType(typeId: 1)
class Order extends HiveObject {
  @HiveField(0)
  String customerName;

  @HiveField(1)
  DateTime orderDate;

  @HiveField(2)
  int totalItems;

  @HiveField(3)
  int totalPrice;

  Order({
    required this.customerName,
    required this.orderDate,
    required this.totalItems,
    required this.totalPrice,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    customerName: json['customer_name'] as String,
    orderDate: DateTime.parse(json['order_date'] as String),
    totalItems: json['total_items'] as int,
    totalPrice: json['total_price'] as int,
  );

  Map<String, dynamic> toJson() => {
    'customer_name': customerName,
    'order_date': orderDate.toIso8601String(),
    'total_items': totalItems,
    'total_price': totalPrice,
  };
}
