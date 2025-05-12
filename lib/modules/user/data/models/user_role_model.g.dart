// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserRoleModelAdapter extends TypeAdapter<UserRoleModel> {
  @override
  final int typeId = 2;

  @override
  UserRoleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserRoleModel(
      id: fields[0] as int,
      role: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserRoleModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRoleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
