import 'package:flutter/material.dart';
import 'package:pos_app/modules/common/widgets/barcode/barcode_scanner.dart';
import 'package:pos_app/utils/responsive_helper.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper responsive = ResponsiveHelper(MediaQuery.of(context).size);

    return SizedBox(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white.withValues(alpha: 0.9),
        ),
        child: TextField(
          controller: controller,
          style: TextStyle(
            color: Colors.black,
            fontSize: responsive.fontSize(20),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.blueGrey,
              fontSize: responsive.fontSize(20),
            ),
            prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.qr_code_scanner_outlined,
                color: Colors.blueAccent,
              ),
              onPressed: () {
                // Navigasi ke halaman BarcodeScanner
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BarcodeScanner()),
                );
              },
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          ),
        ),
      ),
    );
  }
}
