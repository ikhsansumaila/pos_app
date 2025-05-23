import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/auth/auth_controller.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/dashboard/sales_chart.dart';
import 'package:pos_app/modules/dashboard/sales_dashboard_controller.dart';
import 'package:pos_app/utils/styles.dart';

class SalesDashboardView extends StatefulWidget {
  const SalesDashboardView({super.key});

  @override
  State<SalesDashboardView> createState() => _SalesDashboardViewState();
}

class _SalesDashboardViewState extends State<SalesDashboardView> {
  final controller = Get.put(SalesDashboardController());

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final user = authController.getUserLoginData();

    if (user == null) {
      return const Center(child: Text("Anda tidak memiliki akses"));
    }

    return Scaffold(
      appBar: MyAppBar(title: 'Selamat Datang ${user.nama}'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TextField untuk search (optional)
            // TextField(
            //   decoration: InputDecoration(
            //     labelText: "Cari Nama/Kode Barang",
            //     border: OutlineInputBorder(),
            //   ),
            //   onChanged: controller.setSearchQuery,
            // ),
            // SizedBox(height: 16),

            // Tanggal Mulai
            Obx(() {
              return GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: controller.startDate.value ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: controller.endDate.value ?? DateTime.now(),
                  );
                  if (picked != null) {
                    controller.setDateRange(picked, controller.endDate.value);
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: AppStyles.textFieldDecoration(
                      hintText: 'Tanggal Mulai',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                      text:
                          controller.startDate.value == null
                              ? ''
                              : controller.formatDate(controller.startDate.value!),
                    ),
                  ),
                ),
              );
            }),
            SizedBox(height: 10),

            // Tanggal Akhir
            Obx(() {
              return GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: controller.endDate.value ?? DateTime.now(),
                    firstDate: controller.startDate.value ?? DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    controller.setDateRange(controller.startDate.value, picked);
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: AppStyles.textFieldDecoration(
                      hintText: 'Tanggal Akhir',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                      text:
                          controller.endDate.value == null
                              ? ''
                              : controller.formatDate(controller.endDate.value!),
                    ),
                  ),
                ),
              );
            }),
            // SizedBox(height: 10),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton.icon(
            //     icon: Icon(Icons.bar_chart),
            //     label: Text("Tampilkan"),
            //     onPressed: () {
            //       controller.applyFilter();
            //     },
            //   ),
            // ),
            SizedBox(height: 20),
            Obx(() {
              return DropdownButton<SalesViewType>(
                value: controller.viewType.value,
                items: const [
                  DropdownMenuItem(
                    value: SalesViewType.perTanggal,
                    child: Text('Penjualan Per Tanggal'),
                  ),
                  DropdownMenuItem(
                    value: SalesViewType.perProduk,
                    child: Text('Penjualan Per Produk'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    controller.viewType.value = val;
                    setState(() {});
                  }
                },
              );
            }),

            SizedBox(height: 16),

            // Chart
            Expanded(
              child: Obx(() {
                final isEmpty = controller.filteredSales.isEmpty;

                if (isEmpty) {
                  return Center(child: Text('Tidak ada data'));
                }

                return SizedBox(
                  height: 50,
                  child: SalesChart(
                    data: controller.filteredSales,
                    groupBy:
                        controller.viewType.value == SalesViewType.perTanggal
                            ? SalesChartGroupBy.perTanggal
                            : SalesChartGroupBy.perProduk,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
