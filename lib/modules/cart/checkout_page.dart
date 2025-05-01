import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/pos/controller.dart';

class CheckoutPage extends StatelessWidget {
  final POSController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('POS - Checkout')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Total Payment: \$${controller.total.toStringAsFixed(2)}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.cart.clear();
                Get.offAllNamed('/');
                Get.snackbar('Success', 'Checkout completed!');
              },
              child: Text('Complete Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
