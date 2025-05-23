import 'dart:math';

import 'package:get/get.dart';
import 'package:pos_app/modules/dashboard/sales_model.dart';

enum SalesViewType { perTanggal, perProduk }

class SalesDashboardController extends GetxController {
  var sales = <SalesDataModel>[].obs;
  var filteredSales = <SalesDataModel>[].obs;

  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();
  var searchQuery = ''.obs;

  // ... existing properties
  var viewType = SalesViewType.perTanggal.obs;

  @override
  void onInit() {
    super.onInit();
    // Dummy data

    for (var i = 0; i < 10; i++) {
      sales.add(
        SalesDataModel(
          date: DateTime.now().subtract(Duration(days: i + 1)),
          productName: "Produk ${i + 1}",
          productCode: "P000${i + 1}",
          totalSales: (Random().nextInt(1000) + 100).toDouble(), //(i + 1) * 10000,
        ),
      );
    }
    filterSales();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    startDate.value = start;
    endDate.value = end;
    filterSales();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query.toLowerCase();
    filterSales();
  }

  void filterSales() {
    filteredSales.value =
        sales.where((sale) {
          final matchDate =
              (startDate.value == null ||
                  sale.date.isAfter(startDate.value!.subtract(Duration(days: 1)))) &&
              (endDate.value == null || sale.date.isBefore(endDate.value!.add(Duration(days: 1))));
          final matchQuery =
              sale.productName.toLowerCase().contains(searchQuery.value) ||
              sale.productCode.toLowerCase().contains(searchQuery.value);
          return matchDate && matchQuery;
        }).toList();
  }

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  void applyFilter() {
    // Logika filter berdasarkan startDate, endDate, dan searchQuery
    final start = startDate.value;
    final end = endDate.value;
    final query = searchQuery.value.toLowerCase();

    filteredSales.value =
        sales.where((sale) {
          final inRange =
              start != null && end != null
                  ? sale.date.isAfter(start.subtract(Duration(days: 1))) &&
                      sale.date.isBefore(end.add(Duration(days: 1)))
                  : true;
          final matchQuery =
              sale.productName.toLowerCase().contains(query) ||
              sale.productCode.toLowerCase().contains(query);
          return inRange && matchQuery;
        }).toList();
  }

  // Optional: Data chart untuk per produk
  List<SalesDataModel> get salesGroupedByProduct {
    final Map<String, SalesDataModel> map = {};
    for (var sale in filteredSales) {
      final key = sale.productCode;
      if (!map.containsKey(key)) {
        map[key] = SalesDataModel(
          date: sale.date, // bisa pakai DateTime.now() juga
          productName: sale.productName,
          productCode: sale.productCode,
          totalSales: sale.totalSales,
        );
      } else {
        map[key]!.totalSales += sale.totalSales;
      }
    }
    return map.values.toList();
  }
}
