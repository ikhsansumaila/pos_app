import 'package:hive/hive.dart';
import 'package:pos_app/core/services/sync/sync_api_service.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

part 'product_model.g.dart';

@HiveType(typeId: HiveTypeIds.product)
class ProductModel extends HiveObject implements SyncableHiveObject<ProductModel> {
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
  int stok;

  @HiveField(12)
  int storeId;

  @HiveField(13)
  String storeName;

  String? barcodeUrl = '';

  ProductModel({
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
    required this.stok,
    required this.storeId,
    required this.storeName,
    this.barcodeUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
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
    stok: json['stok'] as int,
    storeId: json['store_id'] as int,
    storeName: json['store_name'] as String,
    barcodeUrl: json['barcode_url'] as String?,
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
    'stok': stok,
    'store_id': storeId,
    'store_name': storeName,
    'barcode_url': barcodeUrl,
  };

  @override
  int get modelId => idBrg;

  @override
  bool isDifferent(ProductModel other) {
    return kodeBrg != other.kodeBrg ||
        namaBrg != other.namaBrg ||
        satuan != other.satuan ||
        hargaBeli != other.hargaBeli ||
        margin != other.margin ||
        hargaJual != other.hargaJual ||
        gambar != other.gambar ||
        status != other.status ||
        createdAt != other.createdAt ||
        userid != other.userid ||
        stok != other.stok ||
        storeId != other.storeId ||
        storeName != other.storeName;
  }
}
