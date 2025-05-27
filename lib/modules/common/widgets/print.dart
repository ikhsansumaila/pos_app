// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pos_app/modules/cart/model/cart_item_model.dart';
import 'package:pos_app/utils/formatter.dart';
import 'package:printing/printing.dart';

// class BluetoothPrintPage extends StatefulWidget {
//   const BluetoothPrintPage({super.key});

//   @override
//   _BluetoothPrintPageState createState() => _BluetoothPrintPageState();
// }

// class _BluetoothPrintPageState extends State<BluetoothPrintPage> {
//   BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
//   List<BluetoothDevice> devices = [];
//   BluetoothDevice? selectedDevice;
//   bool isConnected = false;

//   @override
//   void initState() {
//     super.initState();
//     initBluetooth();
//   }

//   void initBluetooth() async {
//     bool? isOn = await bluetooth.isOn;
//     if (isOn == true) {
//       devices = await bluetooth.getBondedDevices();
//       setState(() {});
//     }
//   }

//   void connectToDevice(BluetoothDevice device) async {
//     await bluetooth.connect(device);
//     setState(() {
//       selectedDevice = device;
//       isConnected = true;
//     });
//   }

//   void printTest() {
//     if (kDebugMode) {
//       print("Simulasi Cetak: \n------------------");
//       print("TOKO ABC\nTotal: Rp 50.000\nTerima kasih!");
//       print("------------------");
//       return;
//     }

//     if (isConnected) {
//       bluetooth.printCustom("TOKO ABC", 3, 1);
//       bluetooth.printNewLine();
//       bluetooth.printCustom("Total: Rp 50.000", 2, 1);
//       bluetooth.printNewLine();
//       bluetooth.printCustom("Terima kasih!", 1, 1);
//       bluetooth.printNewLine();
//       bluetooth.paperCut();
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Belum terhubung ke printer")));
//     }
//   }

//   void simulatePrintToPDF() {
//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.Page(
//         build:
//             (context) => pw.Center(
//               child: pw.Text('Struk Simulasi\nTotal: Rp 50.000\nTerima Kasih!'),
//             ),
//       ),
//     );

//     Printing.layoutPdf(onLayout: (format) async => pdf.save());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Cetak Bluetooth")),
//       body: Column(
//         children: [
//           DropdownButton<BluetoothDevice>(
//             hint: Text("Pilih Printer"),
//             value: selectedDevice,
//             onChanged: (device) {
//               if (device != null) connectToDevice(device);
//             },
//             items:
//                 devices
//                     .map(
//                       (d) => DropdownMenuItem(
//                         value: d,
//                         child: Text(d.name ?? "Unknown"),
//                       ),
//                     )
//                     .toList(),
//           ),
//           ElevatedButton.icon(
//             icon: Icon(Icons.print),
//             label: Text("Cetak"),
//             onPressed: printTest,
//           ),
//         ],
//       ),
//     );
//   }
// }

class PrintPDF extends StatelessWidget {
  const PrintPDF({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simulasi Cetak PDF')),
      body: Center(
        child: ElevatedButton.icon(
          icon: Icon(Icons.picture_as_pdf),
          label: Text("Simulasi Struk PDF"),
          // onPressed: cetakStrukPDF,
          onPressed: () {},
        ),
      ),
    );
  }
}

Future<void> cetakStrukPDF(
  List<CartItemModel> cartItems, {
  required String userName,
  required String storeName,
  required String storeAddress,
  required double subTotal,
  required double discount,
  required double totalPayment,
}) async {
  final pdf = pw.Document();
  // var storeName = cartItems[0].product.storeName;

  pdf.addPage(
    pw.Page(
      // theme: pw.ThemeData(),
      pageFormat: PdfPageFormat.roll80, // Ukuran struk thermal
      build: (context) {
        return pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                storeName,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Center(
              child: pw.Text(
                storeAddress,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(fontSize: 7),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Kasir: $userName',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: 8),
                ),
                pw.Text(AppFormatter.dateTime(DateTime.now()), style: pw.TextStyle(fontSize: 7)),
              ],
            ),
            pw.Divider(),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(flex: 2, child: pw.Text('Qty', style: pw.TextStyle(fontSize: 8))),
                pw.Expanded(
                  flex: 4,
                  child: pw.Text('Nama Barang', style: pw.TextStyle(fontSize: 8)),
                ),
                pw.Expanded(child: pw.Text('Harga', style: pw.TextStyle(fontSize: 8))),
              ],
            ),

            pw.Divider(),
            ...cartItems.map((item) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 4),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text(item.quantity.toString(), style: pw.TextStyle(fontSize: 7)),
                    ),

                    // Nama Barang (kiri) - bisa multiline
                    pw.Expanded(
                      flex: 3,
                      child: pw.Text(
                        item.product.namaBrg!,
                        style: pw.TextStyle(fontSize: 7),
                        maxLines: 3,
                        overflow: pw.TextOverflow.clip,
                      ),
                    ),

                    // Qty dan Harga (kanan)
                    pw.SizedBox(width: 8), // spasi antara nama dan info kanan
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          AppFormatter.currency(item.product.hargaJual!.toDouble()),
                          style: pw.TextStyle(fontSize: 7),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

            pw.Divider(),

            pw.SizedBox(height: 10),
            pw.Text('Jumlah Item: ${cartItems.length}', style: pw.TextStyle(fontSize: 8)),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Subtotal:', style: pw.TextStyle(fontSize: 8)),
                    pw.Text('Diskon:', style: pw.TextStyle(fontSize: 8)),
                    pw.Text('Total:', style: pw.TextStyle(fontSize: 8)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(AppFormatter.currency(subTotal), style: pw.TextStyle(fontSize: 8)),
                    pw.Text(AppFormatter.currency(discount), style: pw.TextStyle(fontSize: 8)),
                    pw.Text(AppFormatter.currency(totalPayment), style: pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 30),
            pw.Center(child: pw.Text('Terima Kasih')),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}
