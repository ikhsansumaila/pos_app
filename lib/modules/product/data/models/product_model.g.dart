// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 40;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      idBrg: fields[0] as int?,
      cacheId: fields[1] as int?,
      kodeBrg: fields[2] as String?,
      namaBrg: fields[3] as String?,
      satuan: fields[4] as String?,
      hargaBeli: fields[5] as int?,
      margin: fields[6] as int?,
      hargaJual: fields[7] as int?,
      gambar: fields[8] as String?,
      status: fields[9] as String?,
      createdAt: fields[10] as String?,
      userid: fields[11] as int?,
      nama: fields[12] as String?,
      stok: fields[13] as int?,
      stokUpdatedAt: fields[14] as String?,
      storeId: fields[15] as int?,
      storeName: fields[16] as String?,
      barcodeUrl: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.idBrg)
      ..writeByte(1)
      ..write(obj.cacheId)
      ..writeByte(2)
      ..write(obj.kodeBrg)
      ..writeByte(3)
      ..write(obj.namaBrg)
      ..writeByte(4)
      ..write(obj.satuan)
      ..writeByte(5)
      ..write(obj.hargaBeli)
      ..writeByte(6)
      ..write(obj.margin)
      ..writeByte(7)
      ..write(obj.hargaJual)
      ..writeByte(8)
      ..write(obj.gambar)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.userid)
      ..writeByte(12)
      ..write(obj.nama)
      ..writeByte(13)
      ..write(obj.stok)
      ..writeByte(14)
      ..write(obj.stokUpdatedAt)
      ..writeByte(15)
      ..write(obj.storeId)
      ..writeByte(16)
      ..write(obj.storeName)
      ..writeByte(17)
      ..write(obj.barcodeUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
