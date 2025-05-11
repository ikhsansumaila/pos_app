import 'package:hive/hive.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

part 'user_create_model.g.dart';

@HiveType(typeId: HiveTypeIds.userCreate)
class UserCreateModel extends HiveObject {
  @HiveField(0)
  final String nama;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final int roleId;

  @HiveField(3)
  final int storeId;

  @HiveField(4)
  final int status;

  @HiveField(5)
  final String createdAt;

  @HiveField(6)
  final int userid;

  UserCreateModel({
    required this.nama,
    required this.email,
    required this.roleId,
    required this.storeId,
    required this.status,
    required this.createdAt,
    required this.userid,
  });

  factory UserCreateModel.fromJson(Map<String, dynamic> json) {
    return UserCreateModel(
      nama: json['nama'],
      email: json['email'],
      roleId: json['role_id'],
      storeId: json['store_id'],
      status: json['status'],
      createdAt: json['created_at'],
      userid: json['userid'],
    );
  }

  Map<String, dynamic> toJson() => {
    'nama': nama,
    'email': email,
    'role_id': roleId,
    'store_id': storeId,
    'status': status,
    'created_at': createdAt,
    'userid': userid,
  };
}
