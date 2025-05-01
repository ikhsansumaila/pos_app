import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  double price;

  @HiveField(3)
  String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    title: json['title'],
    price: double.parse(json['price'].toString()),
    imageUrl: json['images'][0] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'image': imageUrl,
  };
}
