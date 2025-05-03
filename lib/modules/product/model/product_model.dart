import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  int idBrg;

  @HiveField(1)
  String kodeBrg;

  @HiveField(2)
  String namaBrg;

  @HiveField(3)
  String satuan;

  @HiveField(4)
  int hargaBeli;

  @HiveField(5)
  int margin;

  @HiveField(6)
  int hargaJual;

  @HiveField(7)
  String? gambar;

  @HiveField(8)
  String status;

  @HiveField(9)
  String createdAt;

  @HiveField(10)
  int userid;

  @HiveField(11)
  String updatedAt;

  @HiveField(12)
  int updatedUserid;

  Product({
    required this.idBrg,
    required this.kodeBrg,
    required this.namaBrg,
    required this.satuan,
    required this.hargaBeli,
    required this.margin,
    required this.hargaJual,
    this.gambar,
    required this.status,
    required this.createdAt,
    required this.userid,
    required this.updatedAt,
    required this.updatedUserid,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    idBrg: json['id_brg'] as int,
    kodeBrg: json['kode_brg'] as String,
    namaBrg: json['nama_brg'] as String,
    satuan: json['satuan'] as String,
    hargaBeli: json['harga_beli'] as int,
    margin: json['margin'] as int,
    hargaJual: json['harga_jual'] as int,
    gambar: json['gambar'] as String?,
    status: json['status'] as String,
    createdAt: json['created_at'] as String,
    userid: json['userid'] as int,
    updatedAt: json['updated_at'] as String,
    updatedUserid: json['updated_userid'] as int,
  );
}
