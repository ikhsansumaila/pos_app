class Order {
  final String customerName;
  final DateTime orderDate;
  final int totalItems;
  final int totalPrice;

  Order({
    required this.customerName,
    required this.orderDate,
    required this.totalItems,
    required this.totalPrice,
  });
}
