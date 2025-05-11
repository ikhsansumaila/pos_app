import 'package:flutter/material.dart';
import 'package:pos_app/modules/common/scrollable_page.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/common/widgets/barcode/barcode_generator.dart';
import 'package:pos_app/modules/common/widgets/image.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/utils/constants/colors.dart';
import 'package:pos_app/utils/formatter.dart';
import 'package:pos_app/utils/responsive_helper.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(MediaQuery.of(context).size);

    return AppBasePage(
      appBar: MyAppBar(title: 'Detail Barang'),
      bodyColor: Colors.white,
      mainWidget: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row for Image and Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  AppImage(
                    url: product.gambar,
                    width: responsive.getProductImageSize(450),
                    height: responsive.getProductImageSize(450),
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 20),

                  // Product Description Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        // Product Name
                        Text(
                          product.namaBrg,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),

                        // Price
                        Text(
                          AppFormatter.currency(product.hargaJual.toDouble()),
                          style: const TextStyle(fontSize: 20, color: AppColors.priceColor, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),

                        // Stock Info
                        Text('Stok: ${product.stok} unit', style: const TextStyle(fontSize: 14, color: Colors.black54)),
                        const SizedBox(height: 16),

                        // Description Section (Expandable)
                        Text('Tidak ada deskripsi.', style: const TextStyle(fontSize: 14), maxLines: 3, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        // TextButton(
                        //   onPressed: () {
                        //     // Navigate to full description or expand
                        //   },
                        //   child: const Text(
                        //     'Lihat Detail Produk',
                        //     style: TextStyle(color: AppColors.primary),
                        //   ),
                        // ),
                        // Barcode Section
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: BarcodeImage(barcodeId: product.kodeBrg)),
                        const SizedBox(height: 16),

                        // Edit Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                                  child: const Text('Ubah Barang'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Additional information (e.g. Reviews)
            // If available, you can display reviews or additional info here.
          ],
        ),
      ),
    );
  }
}
