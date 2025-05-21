// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_create_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionCreateModelAdapter
    extends TypeAdapter<TransactionCreateModel> {
  @override
  final int typeId = 101;

  @override
  TransactionCreateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionCreateModel(
      cacheId: fields[0] as int,
      storeId: fields[1] as int,
      transType: fields[2] as String,
      transDate: fields[3] as String,
      description: fields[4] as String,
      transSubtotal: fields[5] as double,
      transDiscount: fields[6] as double,
      transTotal: fields[7] as double,
      transPayment: fields[8] as double,
      transBalance: fields[9] as double,
      userId: fields[10] as int,
      items: (fields[11] as List).cast<TransactionItemModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, TransactionCreateModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.cacheId)
      ..writeByte(1)
      ..write(obj.storeId)
      ..writeByte(2)
      ..write(obj.transType)
      ..writeByte(3)
      ..write(obj.transDate)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.transSubtotal)
      ..writeByte(6)
      ..write(obj.transDiscount)
      ..writeByte(7)
      ..write(obj.transTotal)
      ..writeByte(8)
      ..write(obj.transPayment)
      ..writeByte(9)
      ..write(obj.transBalance)
      ..writeByte(10)
      ..write(obj.userId)
      ..writeByte(11)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionCreateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionItemModelAdapter extends TypeAdapter<TransactionItemModel> {
  @override
  final int typeId = 102;

  @override
  TransactionItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionItemModel(
      idBarang: fields[0] as int,
      kodeBarang: fields[1] as String,
      description: fields[2] as String,
      qty: fields[3] as int,
      price: fields[4] as double,
      subtotal: fields[5] as double,
      discount: fields[6] as double,
      total: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionItemModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.idBarang)
      ..writeByte(1)
      ..write(obj.kodeBarang)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.qty)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.subtotal)
      ..writeByte(6)
      ..write(obj.discount)
      ..writeByte(7)
      ..write(obj.total);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
