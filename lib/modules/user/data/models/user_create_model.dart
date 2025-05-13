import 'package:hive/hive.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

part 'user_create_model.g.dart';

@HiveType(typeId: HiveTypeIds.userCreate)
class UserCreateModel extends HiveObject {
  @HiveField(0)
  int cacheId;

  @HiveField(1)
  String nama;

  @HiveField(2)
  String email;

  @HiveField(3)
  String password;

  @HiveField(4)
  int roleId;

  @HiveField(5)
  int storeId;

  @HiveField(6)
  int status;

  @HiveField(7)
  int userid;

  UserCreateModel({
    required this.cacheId,
    required this.nama,
    required this.email,
    required this.password,
    required this.roleId,
    required this.storeId,
    required this.status,
    required this.userid,
  });

  factory UserCreateModel.fromJson(Map<String, dynamic> json) {
    return UserCreateModel(
      cacheId: json['cache_id'],
      nama: json['nama'],
      email: json['email'],
      password: json['password'],
      roleId: json['role_id'],
      storeId: json['store_id'],
      status: json['status'],
      userid: json['userid'],
    );
  }

  Map<String, dynamic> toJson() => {
    'cache_id': cacheId,
    'nama': nama,
    'email': email,
    'password': password,
    'role_id': roleId,
    'store_id': storeId,
    'status': status,
    'userid': userid,
  };
}
