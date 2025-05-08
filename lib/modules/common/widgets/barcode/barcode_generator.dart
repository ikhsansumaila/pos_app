import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BarcodeImage extends StatelessWidget {
  final String barcodeId;

  const BarcodeImage({super.key, required this.barcodeId});

  @override
  Widget build(BuildContext context) {
    // Generate barcode (Code128)
    final bc = Barcode.code128();

    // Buat SVG string dari barcode
    final svg = bc.toSvg(barcodeId, width: 300, height: 100);

    return Column(
      children: [
        Text('Barcode: $barcodeId'),
        Center(child: SvgPicture.string(svg)),
      ],
    );
  }
}
