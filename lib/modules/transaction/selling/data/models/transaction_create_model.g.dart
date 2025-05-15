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
      cacheId: fields[10] as int,
      transType: fields[0] as String,
      transDate: fields[1] as String,
      description: fields[2] as String,
      transSubtotal: fields[3] as double,
      transDiscount: fields[4] as double,
      transTotal: fields[5] as double,
      transPayment: fields[6] as double,
      transBalance: fields[7] as double,
      userId: fields[8] as int,
      items: (fields[9] as List).cast<TransactionItemModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, TransactionCreateModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.transType)
      ..writeByte(1)
      ..write(obj.transDate)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.transSubtotal)
      ..writeByte(4)
      ..write(obj.transDiscount)
      ..writeByte(5)
      ..write(obj.transTotal)
      ..writeByte(6)
      ..write(obj.transPayment)
      ..writeByte(7)
      ..write(obj.transBalance)
      ..writeByte(8)
      ..write(obj.userId)
      ..writeByte(9)
      ..write(obj.items)
      ..writeByte(10)
      ..write(obj.cacheId);
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
