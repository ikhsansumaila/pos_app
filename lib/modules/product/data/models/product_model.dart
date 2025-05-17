import 'package:hive/hive.dart';
import 'package:pos_app/modules/sync/service/local_storage_service.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

part 'product_model.g.dart';

@HiveType(typeId: HiveTypeIds.product)
class ProductModel extends HiveObject implements SyncableHiveObject<ProductModel> {
  @HiveField(0)
  int? idBrg;

  @HiveField(1)
  int? cacheId;

  @HiveField(2)
  String? kodeBrg;

  @HiveField(3)
  String? namaBrg;

  @HiveField(4)
  String? satuan;

  @HiveField(5)
  int? hargaBeli;

  @HiveField(6)
  int? margin;

  @HiveField(7)
  int? hargaJual;

  @HiveField(8)
  String? gambar;

  @HiveField(9)
  String? status;

  @HiveField(10)
  String? createdAt;

  @HiveField(11)
  int? userid;

  @HiveField(12)
  String? nama;

  @HiveField(13)
  int? stok;

  @HiveField(14)
  String? stokUpdatedAt;

  @HiveField(15)
  int? storeId;

  @HiveField(16)
  String? storeName;

  @HiveField(17)
  String? barcodeUrl;

  ProductModel({
    this.idBrg,
    this.cacheId,
    this.kodeBrg,
    this.namaBrg,
    this.satuan,
    this.hargaBeli,
    this.margin,
    this.hargaJual,
    this.gambar = '',
    this.status,
    this.createdAt,
    this.userid,
    this.nama,
    this.stok,
    this.stokUpdatedAt,
    this.storeId,
    this.storeName,
    this.barcodeUrl = '',
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    idBrg: json['id_brg'] as int?,
    cacheId: json['cache_id'] as int?,
    kodeBrg: json['kode_brg'] as String?,
    namaBrg: json['nama_brg'] as String?,
    satuan: json['satuan'] as String?,
    hargaBeli: json['harga_beli'] as int?,
    margin: json['margin'] as int?,
    hargaJual: json['harga_jual'] as int?,
    gambar: json['gambar'] as String?,
    status: json['status'] as String?,
    createdAt: json['created_at'] as String?,
    userid: json['userid'] as int?,
    nama: json['nama'] as String?,
    stok: json['stok'] as int?,
    stokUpdatedAt: json['stok_updated_at'] as String?,
    storeId: json['store_id'] as int?,
    storeName: json['store_name'] as String?,
    barcodeUrl: json['barcode_url'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id_brg': idBrg,
    'cache_id': cacheId,
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
    'nama': nama,
    'stok': stok,
    'stok_updated_at': stokUpdatedAt,
    'store_id': storeId,
    'store_name': storeName,
    'barcode_url': barcodeUrl,
  };

  Map<String, dynamic> toJsonCreate() => {
    'nama_brg': namaBrg,
    'satuan': satuan,
    'harga_beli': hargaBeli,
    'margin': margin,
  };

  @override
  int get modelId => idBrg ?? 0;

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
        nama != other.nama ||
        stok != other.stok ||
        stokUpdatedAt != other.stokUpdatedAt ||
        storeId != other.storeId ||
        storeName != other.storeName ||
        barcodeUrl != other.barcodeUrl;
  }
}
