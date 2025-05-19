import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/common/scrollable_page.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/common/widgets/image.dart';
import 'package:pos_app/modules/product/controller/product_contoller.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/utils/constants/colors.dart';
import 'package:pos_app/utils/formatter.dart';
import 'package:pos_app/utils/styles.dart';

class StockMutationPage extends StatefulWidget {
  const StockMutationPage({super.key});

  @override
  State<StockMutationPage> createState() => _StockMutationPageState();
}

class _StockMutationPageState extends State<StockMutationPage> {
  final jumlahController = TextEditingController();
  final ProductController productController = Get.find();
  ProductModel? selectedTargetProduct;
  late ProductModel sourceProduct;

  @override
  void initState() {
    super.initState();
    sourceProduct = Get.arguments as ProductModel;
  }

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      appBar: MyAppBar(title: "Pecah Stok"),
      mainWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductCard(title: "Barang Asal", product: sourceProduct, includeInput: true),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Icon(
                Icons.swap_vert_rounded,
                size: 48,
                color: const Color.fromARGB(255, 24, 142, 30),
              ),
            ),
          ),
          _buildTargetProductCard(),
        ],
      ),
      fixedBottomWidget: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // Handle checkout logic here
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
          child: Text('Pecah Stok'),
        ),
      ),
    );
  }

  Widget _buildProductCard({
    required String title,
    required ProductModel product,
    bool includeInput = false,
  }) {
    return Card(
      color: Colors.white.withValues(alpha: 0.95),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(product.gambar),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 8),
                  Text("Kode: ${product.kodeBrg}", style: TextStyle(fontSize: 16)),
                  Text("Nama: ${product.namaBrg}", style: TextStyle(fontSize: 16)),
                  Text("Satuan: ${product.satuan}", style: TextStyle(fontSize: 16)),
                  Text(
                    'Stok: ${product.stok ?? 0}',
                    style: TextStyle(fontSize: 16),
                  ), // TODO: pakai stok aktual
                  Text(
                    "Harga: ${AppFormatter.currency((product.hargaJual ?? 0).toDouble())}",
                    style: TextStyle(
                      color: AppColors.priceColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (includeInput) ...[
                    SizedBox(height: 12),
                    TextField(
                      controller: jumlahController,
                      keyboardType: TextInputType.number,
                      decoration: AppStyles.textFieldDecoration(
                        hintText: 'Jumlah yang akan dipecah',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetProductCard() {
    return Card(
      color: Colors.white.withValues(alpha: 0.95),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Barang Tujuan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 12),
            Autocomplete<ProductModel>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                return productController.products.where((ProductModel p) {
                  return (p.namaBrg ?? '').toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      ) &&
                      p.idBrg != sourceProduct.idBrg;
                });
              },
              displayStringForOption: (ProductModel option) => option.namaBrg ?? '',
              onSelected: (ProductModel selection) {
                setState(() {
                  selectedTargetProduct = selection;
                });
              },
              fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onEditingComplete: onEditingComplete,
                  decoration: AppStyles.textFieldDecoration(hintText: 'Cari nama barang tujuan'),
                );
              },
            ),
            if (selectedTargetProduct != null) ...[
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductImage(selectedTargetProduct!.gambar),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Kode: ${selectedTargetProduct!.kodeBrg}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Nama: ${selectedTargetProduct!.namaBrg}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Satuan: ${selectedTargetProduct!.satuan}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Stok: ${selectedTargetProduct!.stok}',
                          style: TextStyle(fontSize: 16),
                        ), // TODO: pakai stok aktual
                        Text(
                          "Harga: ${AppFormatter.currency((selectedTargetProduct?.hargaJual ?? 0).toDouble())}",
                          style: TextStyle(
                            color: AppColors.priceColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 12),
                        TextField(
                          controller: jumlahController,
                          keyboardType: TextInputType.number,
                          decoration: AppStyles.textFieldDecoration(
                            hintText: 'Jumlah yang akan ditambah',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(String? url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AppImage(
        width: 70,
        height: 70,
        errorBuilder:
            (context, error, stackTrace) => Container(
              color: Colors.grey.shade200,
              child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
            ),
      ),
    );
  }
}
