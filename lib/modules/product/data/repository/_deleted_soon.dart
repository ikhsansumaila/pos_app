// import 'dart:developer';

// import 'package:pos_app/data/models/product_model.dart';
// import 'package:pos_app/utils/api/base.dart';
// import 'package:pos_app/utils/api/response.dart';

// class ProductRepository extends BaseRepository {
//   Future<ApiResponse<List<Product>>> getAllProducts() {
//     return safeRequest<
//       List<Product>
//     >(() => dio.get('https://esiportal.com/api/produk?store=1'), (data) {
//       return (data as List).map((e) {
//         Map<String, dynamic> map = e;
//         log("map $map");
//         var product = Product.fromJson(map);
//         log("product.idBrg ${product.idBrg} ${product.idBrg.runtimeType}");
//         log(
//           "product.hargaBeli ${product.hargaBeli} ${product.hargaBeli.runtimeType}",
//         );
//         return Product.fromJson(map);
//       }).toList();
//     });
//   }

//   Future<ApiResponse<Product>> getProductById(int id) {
//     return safeRequest<Product>(
//       () => dio.get('https://dummyjson.com/products/$id'),
//       (data) => Product.fromJson(data),
//     );
//   }
// }
