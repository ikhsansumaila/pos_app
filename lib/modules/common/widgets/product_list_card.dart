import 'package:flutter/material.dart';
import 'package:pos_app/data/models/product_model.dart';
import 'package:pos_app/utils/responsive_helper.dart';

class ProductListCard extends StatelessWidget {
  const ProductListCard({
    super.key,
    required this.product,
    required this.child,
  });

  final Product product;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper responsive = ResponsiveHelper(MediaQuery.of(context).size);
    double circularRadius = 14;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(circularRadius),
      ),
      elevation: 8,
      shadowColor: Colors.black26,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(circularRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: child,
        ),

        // GetBuilder(
        //   init: trxController,
        //   builder: (data) {
        //     final quantity = data.getQuantity(product.idBrg);
        //     int stock = 10;

        //     bool buttonAddEnabled = stock > 0 && quantity < stock;
        //     bool buttonRemoveEnabled = stock > 0 && quantity > 0;
        //     return Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           // ROW: Gambar dan informasi
        //           Row(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               AppImage(url: product.gambar, width: 40, height: 40),
        //               const SizedBox(width: 8),
        //               Expanded(
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Text(
        //                       product.namaBrg,
        //                       style: TextStyle(
        //                         fontWeight: FontWeight.bold,
        //                         fontSize: 8,
        //                         color: Colors.black87,
        //                       ),
        //                     ),
        //                     Text(
        //                       'Rp${NumberFormat("#,##0", "id_ID").format(product.hargaJual)}',
        //                       style: TextStyle(
        //                         color: AppColors.priceColor,
        //                         fontSize: 10,
        //                         fontWeight: FontWeight.bold,
        //                       ),
        //                     ),
        //                     Text(
        //                       '(Stok: $stock)',
        //                       style: TextStyle(
        //                         color: Colors.black87,
        //                         fontSize: 8,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ],
        //           ),
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               InkWell(
        //                 onTap:
        //                     stock == 0
        //                         ? null
        //                         : () {
        //                           Get.toNamed(
        //                             AppRoutes.stockMutation,
        //                             arguments: product,
        //                           );
        //                         },
        //                 child: Row(
        //                   mainAxisSize: MainAxisSize.min,
        //                   children: [
        //                     Icon(
        //                       Icons.call_split,
        //                       color:
        //                           stock == 0 ? Colors.grey : AppColors.primary,
        //                       size: 12,
        //                     ),
        //                     const SizedBox(width: 2), // spasi minimal
        //                     Text(
        //                       'Pecah Stok',
        //                       style: TextStyle(
        //                         color:
        //                             stock == 0
        //                                 ? Colors.grey
        //                                 : AppColors.primary,
        //                         fontSize: 8,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //               // Tombol + / - dan qty
        //               // Row(
        //               //   mainAxisAlignment: MainAxisAlignment.start,
        //               //   children: [
        //               //     AppIconButton(
        //               //       onPressed:
        //               //           buttonRemoveEnabled
        //               //               ? () => data.removeItem(product)
        //               //               : null,
        //               //       icon: Icons.remove_circle,
        //               //       color:
        //               //           buttonRemoveEnabled ? Colors.red : Colors.grey,
        //               //       size: 12,
        //               //     ),
        //               //     const SizedBox(width: 8),
        //               //     Text(
        //               //       quantity.toString(),
        //               //       style: TextStyle(
        //               //         fontSize: 8,
        //               //         color: stock == 0 ? Colors.grey : Colors.black87,
        //               //       ),
        //               //     ),
        //               //     const SizedBox(width: 8),
        //               //     AppIconButton(
        //               //       onPressed:
        //               //           buttonAddEnabled
        //               //               ? () => data.addItem(product)
        //               //               : null,
        //               //       icon: Icons.add_circle,
        //               //       color:
        //               //           buttonAddEnabled
        //               //               ? AppColors.primary
        //               //               : Colors.grey,
        //               //       size: 12,
        //               //     ),
        //               //   ],
        //               // ),
        //             ],
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }
}
