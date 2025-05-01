class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['title'],
    price: double.parse(json['price'].toString()),
    imageUrl: json['images'][0] ?? '',
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'price': price};
}
