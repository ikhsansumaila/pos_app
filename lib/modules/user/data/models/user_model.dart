import 'package:hive/hive.dart';
import 'package:pos_app/modules/sync/service/local_storage_service.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

part 'user_model.g.dart';

@HiveType(typeId: HiveTypeIds.user)
class UserModel extends HiveObject implements SyncableHiveObject<UserModel> {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int? storeId;

  @HiveField(2)
  String? storeName;

  @HiveField(3)
  String? nama;

  @HiveField(4)
  String? email;

  @HiveField(5)
  String? password;

  @HiveField(6)
  int? roleId;

  @HiveField(7)
  String? role;

  @HiveField(8)
  String? roleName;

  @HiveField(9)
  int? status;

  @HiveField(10)
  String? createdAt;

  @HiveField(11)
  int? cacheId;

  @HiveField(12)
  int? userId;

  UserModel({
    this.id,
    this.storeId,
    this.storeName,
    this.nama,
    this.email,
    this.password,
    this.roleId,
    this.role,
    this.roleName,
    this.status,
    this.createdAt,
    this.cacheId,
    this.userId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      storeId: json['store_id'],
      storeName: json['store_name'],
      nama: json['nama'],
      email: json['email'],
      password: json['password'],
      roleId: json['role_id'],
      role: json['role'],
      roleName: json['role_name'],
      status: json['status'],
      createdAt: json['created_at'],
      cacheId: json['cache_id'],
      userId: json['userid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'store_name': storeName,
      'nama': nama,
      'email': email,
      'password': password,
      'role_id': roleId,
      'role': role,
      'role_name': roleName,
      'status': status,
      'created_at': createdAt,
      'cache_id': cacheId,
      'userid': userId,
    };
  }

  Map<String, dynamic> toJsonCreate() => {
    'cache_id': cacheId,
    'nama': nama,
    'email': email,
    'password': password,
    'role_id': roleId,
    'store_id': storeId,
    'userid': userId,
  };

  @override
  int? get modelId => id;

  @override
  bool isDifferent(UserModel other) {
    return id != other.id ||
        storeId != other.storeId ||
        storeName != other.storeName ||
        nama != other.nama ||
        email != other.email ||
        roleId != other.roleId ||
        role != other.role ||
        roleName != other.roleName ||
        status != other.status;
  }
}
