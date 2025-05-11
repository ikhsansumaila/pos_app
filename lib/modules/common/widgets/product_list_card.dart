import 'package:flutter/material.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';

class ProductListCard extends StatelessWidget {
  const ProductListCard({super.key, required this.product, required this.child});

  final ProductModel product;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    double circularRadius = 14;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(circularRadius)),
      elevation: 8,
      shadowColor: Colors.black26,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(circularRadius)),
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), child: child),
      ),
    );
  }
}
