import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/modules/common/app_bar.dart';
import 'package:pos_app/modules/transaction/purchase_order/order_controller.dart';
import 'package:pos_app/utils/constants/colors.dart';

class OrdersPage extends StatelessWidget {
  final controller = Get.put(OrdersController());

  OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Daftar Pesanan'),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Expanded(
          child: Obx(() {
            if (controller.orders.isEmpty) {
              return Center(child: Text('Belum ada pesanan.'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: controller.orders.length,
              separatorBuilder: (_, __) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = controller.orders[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      'Pemesan : ${order.customerName}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(
                          'Tanggal: ${DateFormat('dd MMM yyyy').format(order.orderDate)}',
                        ),
                        Text('Jumlah Item: ${order.totalItems}'),
                      ],
                    ),
                    trailing: Text(
                      'Rp${NumberFormat("#,##0", "id_ID").format(order.totalPrice)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.priceColor,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
