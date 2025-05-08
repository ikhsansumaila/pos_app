import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/data/models/product_model.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/common/widgets/image.dart';
import 'package:pos_app/utils/constants/colors.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Detail Barang'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppImage(
              url: product.gambar,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              product.namaBrg,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Rp${NumberFormat("#,##0", "id_ID").format(product.hargaJual)}',
              style: const TextStyle(fontSize: 18, color: AppColors.priceColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Stok: ${product.stok}',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            // Text(
            //   product.deskripsi ?? 'Tidak ada deskripsi.',
            //   style: const TextStyle(fontSize: 14),
            // ),
          ],
        ),
      ),
    );
  }
}
