import 'package:hive/hive.dart';
import 'package:pos_app/core/services/sync_api_service.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject implements SyncableHiveObject<Product> {
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
  );

  Map<String, dynamic> toJson() => {
    'id_brg': idBrg,
    'kode_brg': kodeBrg,
    'nama_brg': namaBrg,
    'satuan': satuan,
    'harga_beli': hargaBeli,
    'margin': margin,
    'harga_jual': hargaJual,
    'gambar': gambar,
    'status': status,
    'created_at': createdAt,
    'userid': userid,
  };

  @override
  int get modelId => idBrg;

  @override
  bool isDifferent(Product other) {
    return kodeBrg != other.kodeBrg ||
        namaBrg != other.namaBrg ||
        satuan != other.satuan ||
        hargaBeli != other.hargaBeli ||
        margin != other.margin ||
        hargaJual != other.hargaJual ||
        gambar != other.gambar ||
        status != other.status ||
        createdAt != other.createdAt ||
        userid != other.userid;
  }
}
