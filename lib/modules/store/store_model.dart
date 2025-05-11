class StoreModel {
  final int id;
  final String name;

  StoreModel({required this.id, required this.name});

  @override
  String toString() => name;
}
