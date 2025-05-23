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
import 'package:pos_app/utils/constants/colors.dart';
import 'package:pos_app/utils/formatter.dart';
import 'package:pos_app/utils/styles.dart';

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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, popCallback) {
        if (didPop) return;

        Future.microtask(() async {
          final shouldPop = await _showExitConfirmationDialog(context);
          if (shouldPop && context.mounted) {
            controller.clearForm();
            Get.back();
          }
        });
      },
      child: AppBasePage(
        appBar: MyAppBar(title: "Form Pembelian"),
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
        fixedBottomWidget: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            return ElevatedButton(
              onPressed: controller.trxItems.isNotEmpty ? controller.submit : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
              child: Text('Simpan'),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSelectProduct() {
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
                final query = textEditingValue.text.toLowerCase();
                return productController.products.where((ProductModel p) {
                  final name = p.namaBrg?.toLowerCase() ?? '';
                  return query.isEmpty || name.contains(query);
                });
              },
              displayStringForOption: (ProductModel option) => option.namaBrg ?? '',
              onSelected: (ProductModel selection) {
                setState(() {
                  controller.selectedProduct.value = selection;
                  controller.searchController.text = selection.namaBrg ?? '';
                  controller.priceController.clear();
                  controller.qtyController.clear();
                });
              },
              fieldViewBuilder: (context, textFieldController, focusNode, onEditingComplete) {
                textFieldController.text = controller.searchController.text;

                return TextField(
                  controller: textFieldController,
                  focusNode: focusNode,
                  onEditingComplete: onEditingComplete,
                  decoration: AppStyles.textFieldDecoration(
                    hintText: 'Cari nama barang',
                    suffixIcon:
                        textFieldController.text.isNotEmpty
                            ? IconButton(
                              iconSize: 16,
                              icon: Icon(Icons.clear),
                              color: Colors.red,
                              onPressed: () {
                                setState(() {
                                  controller.clearProductSearchForm();
                                  // hilangkan fokus Autocomplete
                                  FocusScope.of(context).unfocus();
                                });
                              },
                            )
                            : null,
                  ),
                  // ON CHANGED TYPING
                  onChanged: (value) {
                    setState(() {
                      controller.searchController.text = value;
                      controller.formSearchValidate();
                    });
                  },
                );
                // });
              },
            ),
            _selectedProduct(),
            SizedBox(height: 16),

            // BUTTON ADD ITEMS
            Obx(() {
              return Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed:
                      controller.buttonAddEnable.value == false
                          ? null
                          : () {
                            setState(() {
                              controller.addItem(controller.selectedProduct.value!);
                              controller.clearProductSearchForm();

                              // hilangkan fokus Autocomplete
                              FocusScope.of(context).unfocus();
                            });
                          },
                  child: Text("Tambah"),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _selectedProduct() {
    return Obx(() {
      if (controller.selectedProduct.value != null) {
        return Column(
          children: [
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
            SizedBox(height: 8),
            TextField(
              controller: controller.qtyController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: AppStyles.textFieldDecoration(hintText: 'Qty'),
              onChanged: (_) => controller.formSearchValidate(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: controller.priceController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: AppStyles.textFieldDecoration(hintText: 'Harga Beli'),
              onChanged: (value) {
                setState(() {
                  controller.formSearchValidate();
                  controller.priceController.text = AppFormatter.currency(
                    double.tryParse(value) ?? 0,
                  );
                });
              },
            ),
            SizedBox(height: 16),
          ],
        );
      }

      return SizedBox();
    });
  }

  List<Widget> _buildItems() {
    if (controller.trxItems.isNotEmpty) {
      return <Widget>[
        Divider(height: 32, thickness: 1),
        Text(
          "Daftar barang yang dibeli",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: controller.addedProducts.length,
          itemBuilder: (context, index) {
            log('index $index');
            final product = controller.addedProducts[index];
            final trxItem = controller.trxItems[index];

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(product.namaBrg ?? 'Tidak diketahui'),
                    subtitle: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text.rich(
                            textAlign: TextAlign.left,
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: AppFormatter.currency(trxItem.price),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.priceColor,
                                    fontSize: 16,
                                  ),
                                ),
                                TextSpan(
                                  text: ' x (${trxItem.qty})',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        controller.removeItem(index);
                        setState(() {});
                      },
                    ),
                  ),
                ),
                if (index != controller.addedProducts.length - 1)
                  Divider(height: 0, thickness: 1, color: Colors.grey.shade300),
              ],
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

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    var result =
        await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Keluar Halaman'),
                content: const Text(
                  'Data akan terhapus, Anda yakin ingin meninggalkan halaman ini?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Tidak'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Ya'),
                  ),
                ],
              ),
        ) ??
        false;
    return result;
  }
}
