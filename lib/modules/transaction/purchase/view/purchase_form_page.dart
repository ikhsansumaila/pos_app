// pages/purchase_form_page.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/common/scrollable_page.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/common/widgets/image.dart';
import 'package:pos_app/modules/product/controller/product_contoller.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/modules/transaction/purchase/controller/purchase_controller.dart';
import 'package:pos_app/utils/formatter.dart';

class PurchaseFormPage extends StatefulWidget {
  const PurchaseFormPage({super.key});

  @override
  State<PurchaseFormPage> createState() => _PurchaseFormPageState();
}

class _PurchaseFormPageState extends State<PurchaseFormPage> {
  final controller = Get.put(PurchaseController());
  final productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Pembelian Baru'),
      body: AppBasePage(
        bodyColor: Colors.white,
        mainWidget: Column(
          children: [
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Text("Tanggal: ${AppFormatter.dateTime(DateTime.now())}"),
            ),
            _buildSelectProduct(),
            ..._buildItems(),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectProduct() {
    bool buttonAddDisable = false;
    log('controller.priceController.text ${controller.priceController.text}');

    log('controller.priceController.value ${controller.priceController.value}');
    if (controller.selectedProduct.value == null ||
        AppFormatter.parseCurrency(controller.priceController.text) == 0 ||
        controller.qtyController.text == '') {
      buttonAddDisable = true;
    }

    return Card(
      color: Colors.white.withValues(alpha: 0.95),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pilih Barang", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 12),
            Autocomplete<ProductModel>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                return productController.products.where((ProductModel p) {
                  return (p.namaBrg ?? '').toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  );
                });
              },
              displayStringForOption: (ProductModel option) => option.namaBrg ?? '',
              onSelected: (ProductModel selection) {
                setState(() {
                  controller.selectedProduct.value = selection;
                });
              },
              fieldViewBuilder: (context, textEditingController, focusNode, onEditingComplete) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  onEditingComplete: onEditingComplete,
                  decoration: InputDecoration(
                    labelText: "Cari nama barang",
                    border: OutlineInputBorder(),
                    suffixIcon:
                        textEditingController.text.isNotEmpty
                            ? IconButton(
                              iconSize: 16,
                              icon: Icon(Icons.clear),
                              color: Colors.red,
                              onPressed: () {
                                textEditingController.clear();
                                controller.clearProduct();
                                setState(() {});
                              },
                            )
                            : null,
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                );
              },
            ),
            if (controller.selectedProduct.value != null) ...[
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductImage(controller.selectedProduct.value!.gambar),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Kode: ${controller.selectedProduct.value!.kodeBrg}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Nama: ${controller.selectedProduct.value!.namaBrg}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Satuan: ${controller.selectedProduct.value!.satuan}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            if (controller.selectedProduct.value != null) ...[
              SizedBox(height: 8),
              TextField(
                controller: controller.qtyController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: "Qty",
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: controller.priceController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: "Harga Beli",
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (value) {
                  setState(() {
                    controller.priceController.text = AppFormatter.currency(
                      double.tryParse(value) ?? 0,
                    );
                  });
                },
              ),
              SizedBox(height: 16),
            ],
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed:
                    buttonAddDisable
                        ? null
                        : () {
                          controller.addItem(controller.selectedProduct.value!);
                          setState(() {});
                        },
                child: Text("Tambah"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildItems() {
    if (controller.trxItems.isNotEmpty) {
      return <Widget>[
        Divider(height: 32, thickness: 1),
        Text("Daftar Barang Dibeli", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: controller.addedProducts.length,
          itemBuilder: (context, index) {
            log('index $index');
            final product = controller.addedProducts[index];
            final trxItem = controller.trxItems[index];

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(product.namaBrg ?? 'Tidak diketahui'),
                subtitle: Text(
                  "Qty: ${trxItem.qty} • Harga: ${AppFormatter.currency(trxItem.price)}",
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    controller.removeItem(index);
                    setState(() {});
                  },
                ),
              ),
            );
          },
        ),
      ];
    }

    return [];
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
