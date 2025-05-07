import 'package:hive/hive.dart';
import 'package:pos_app/core/services/sync_api_service.dart';

part './order_model.g.dart';

@HiveType(typeId: 1)
class Order extends HiveObject implements SyncableHiveObject<Order> {
  @HiveField(0)
  int id;

  @HiveField(1)
  String customerName;

  @HiveField(2)
  DateTime orderDate;

  @HiveField(3)
  int totalItems;

  @HiveField(4)
  int totalPrice;

  Order({
    required this.id,
    required this.customerName,
    required this.orderDate,
    required this.totalItems,
    required this.totalPrice,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'] as int,
    customerName: json['customer_name'] as String,
    orderDate: DateTime.parse(json['order_date'] as String),
    totalItems: json['total_items'] as int,
    totalPrice: json['total_price'] as int,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'customer_name': customerName,
    'order_date': orderDate.toIso8601String(),
    'total_items': totalItems,
    'total_price': totalPrice,
  };

  @override
  int get modelId => id;

  @override
  bool isDifferent(Order other) {
    return id != other.id ||
        customerName != other.customerName ||
        orderDate != other.orderDate ||
        totalItems != other.totalItems ||
        totalPrice != other.totalPrice;
  }
}
