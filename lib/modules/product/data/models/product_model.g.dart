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
      idBrg: fields[0] as int,
      kodeBrg: fields[1] as String,
      namaBrg: fields[2] as String,
      satuan: fields[3] as String,
      hargaBeli: fields[4] as int,
      margin: fields[5] as int,
      hargaJual: fields[6] as int,
      gambar: fields[7] as String?,
      status: fields[8] as String,
      createdAt: fields[9] as String,
      userid: fields[10] as int,
      stok: fields[11] as int,
      storeId: fields[12] as int,
      storeName: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.idBrg)
      ..writeByte(1)
      ..write(obj.kodeBrg)
      ..writeByte(2)
      ..write(obj.namaBrg)
      ..writeByte(3)
      ..write(obj.satuan)
      ..writeByte(4)
      ..write(obj.hargaBeli)
      ..writeByte(5)
      ..write(obj.margin)
      ..writeByte(6)
      ..write(obj.hargaJual)
      ..writeByte(7)
      ..write(obj.gambar)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.userid)
      ..writeByte(11)
      ..write(obj.stok)
      ..writeByte(12)
      ..write(obj.storeId)
      ..writeByte(13)
      ..write(obj.storeName);
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
