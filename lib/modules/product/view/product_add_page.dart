import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/modules/common/scrollable_page.dart';
import 'package:pos_app/modules/common/widgets/app_bar.dart';
import 'package:pos_app/modules/common/widgets/barcode/barcode_generator.dart';
import 'package:pos_app/modules/product/controller/product_contoller.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  final productController = Get.find<ProductController>();

  final TextEditingController _kodeController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _satuanController = TextEditingController();
  final TextEditingController _hargaBeliController = TextEditingController();
  final TextEditingController _hargaJualController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();

  File? _imageFile;

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Kamera'),
                onTap: () async {
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );
                  if (picked != null) {
                    setState(() => _imageFile = File(picked.path));
                  }

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Galeri'),
                onTap: () async {
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (picked != null) {
                    setState(() => _imageFile = File(picked.path));
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final product = Product(
        idBrg: DateTime.now().millisecondsSinceEpoch,
        kodeBrg: _kodeController.text,
        namaBrg: _namaController.text,
        satuan: _satuanController.text,
        hargaBeli: int.parse(_hargaBeliController.text),
        margin: 0,
        hargaJual: int.parse(_hargaJualController.text),
        gambar: _imageFile?.path,
        status: 'active',
        createdAt: DateTime.now().toIso8601String(),
        userid: 0,
        stok: int.parse(_stokController.text),
        storeId: 1,
        storeName: 'Toko Default',
      );

      if (await productController.addProduct(product)) {
        Get.snackbar(
          'Berhasil',
          'Barang berhasil ditambahkan',
          icon: const Icon(Icons.check, color: Colors.green),
        );

        Navigator.pop(context); // Close loading
        Get.back(); // Kembali ke halaman sebelumnya
      } else {
        Get.snackbar(
          'Gagal',
          'Barang gagal ditambahkan',
          icon: const Icon(Icons.close, color: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      appBar: MyAppBar(title: 'Tambah Barang'),
      bodyColor: Colors.white,
      mainWidget: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder(
          init: productController,
          builder: (data) {
            if (data.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _kodeController,
                    decoration: const InputDecoration(labelText: 'Kode Barang'),
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(labelText: 'Nama Barang'),
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: _satuanController,
                    decoration: const InputDecoration(labelText: 'Satuan'),
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: _hargaBeliController,
                    decoration: const InputDecoration(labelText: 'Harga Beli'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: _hargaJualController,
                    decoration: const InputDecoration(labelText: 'Harga Jual'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: _stokController,
                    decoration: const InputDecoration(labelText: 'Stok'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickImage,
                    child:
                        _imageFile == null
                            ? Container(
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(child: Text('Upload Gambar')),
                            )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _imageFile!,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                  ),
                  const SizedBox(height: 20),
                  BarcodeImage(barcodeId: '1234567890'),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
      fixedBottomWidget: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Text('Simpan'),
        ),
      ),
    );
  }
}
