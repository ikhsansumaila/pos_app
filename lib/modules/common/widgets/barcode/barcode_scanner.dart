import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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

    log("barccode $code");

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Scan Result"),
            content: Text(code),
            actions: [
              TextButton(
                onPressed: () {
                  _isDialogShown = false;
                  Navigator.of(context).pop();
                  _controller.start();
                },
                child: const Text("Scan Again"),
              ),
              TextButton(
                onPressed:
                    () => Navigator.of(
                      context,
                    ).popUntil((route) => route.isFirst),
                child: const Text("Close"),
              ),
            ],
          ),
    );
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
}
