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

Future<void> cetakStrukPDF(List<CartItemModel> cartItems, double totalPayment) async {
  final pdf = pw.Document();
  var storeName = cartItems[0].product.storeName;

  pdf.addPage(
    pw.Page(
      // theme: pw.ThemeData(),
      pageFormat: PdfPageFormat.roll80, // Ukuran struk thermal
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                storeName ?? '',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 10),

            pw.Text('Tanggal: ${AppFormatter.dateTime(DateTime.now())}'),
            pw.Divider(),
            ...cartItems.map((item) {
              return pw.Text(
                '${item.product.namaBrg}     x${item.quantity}    Rp${item.product.hargaJual}',
              );
            }),
            pw.Divider(),

            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Total: Rp${AppFormatter.currency(totalPayment)}',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Center(child: pw.Text('Terima Kasih!')),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}
