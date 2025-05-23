class SalesDataModel {
  final DateTime date;
  final String productName;
  final String productCode;
  double totalSales;

  SalesDataModel({
    required this.date,
    required this.productName,
    required this.productCode,
    required this.totalSales,
  });
}
