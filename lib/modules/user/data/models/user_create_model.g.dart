// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_create_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserCreateModelAdapter extends TypeAdapter<UserCreateModel> {
  @override
  final int typeId = 1;

  @override
  UserCreateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserCreateModel(
      nama: fields[0] as String,
      email: fields[1] as String,
      roleId: fields[2] as int,
      storeId: fields[3] as int,
      status: fields[4] as int,
      userid: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserCreateModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.roleId)
      ..writeByte(3)
      ..write(obj.storeId)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.userid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserCreateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
