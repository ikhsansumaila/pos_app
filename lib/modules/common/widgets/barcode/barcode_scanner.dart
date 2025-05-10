import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pos_app/modules/product/controller/product_contoller.dart';
import 'package:pos_app/modules/product/data/models/product_model.dart';
import 'package:pos_app/modules/product/view/product_detail_page.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({super.key});

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isDialogShown = false;
  bool _torchOn = false;

  void _onDetect(BarcodeCapture capture) {
    final barcode = capture.barcodes.first;
    final String? code = barcode.rawValue;

    if (code == null || _isDialogShown) return;

    _isDialogShown = true;
    _controller.stop();

    print("barcode $code");

    final local = Get.find<ProductController>();
    final data = local.products;
    // final data = local.getCachedProducts();

    print('data runtime ${data.runtimeType}');
    print('data  $data');
    try {
      Product? product = data.firstWhere(
        (product) => product.kodeBrg.toString() == code,
        orElse: () => throw Exception("Product with ID $code not found!"),
      );

      print("Hasil scan product: ${product.toJson()}");
      Get.back();
      Get.to(() => ProductDetailPage(product: product));
    } catch (e) {
      _showInvalidScanResultDialog(code);
    }
  }

  void _showInvalidScanResultDialog(String code) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Barcode Invalid:"),
            content: Text('$code tidak terdaftar di database'),
            actions: [
              TextButton(
                onPressed: _onScanAgain,
                child: const Text("Scan Ulang"),
              ),
              TextButton(
                onPressed: _onCloseDialog,
                child: const Text("Kembali"),
              ),
            ],
          ),
    );
  }

  void _onScanAgain() {
    setState(() {
      _isDialogShown = false;
    });
    Navigator.of(context).pop();
    _controller.start();
  }

  void _onCloseDialog() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void _toggleTorch() async {
    await _controller.toggleTorch();
    setState(() {
      _torchOn = !_torchOn;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(controller: _controller, onDetect: _onDetect),
        _buildOverlay(),
        _buildFlashlightButton(),
      ],
    );
  }

  Widget _buildOverlay() {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.greenAccent, width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildFlashlightButton() {
    return Positioned(
      bottom: 32,
      left: 0,
      right: 0,
      child: Center(
        child: IconButton(
          onPressed: _toggleTorch,
          icon: Icon(
            _torchOn ? Icons.flash_on : Icons.flash_off,
            size: 32,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
