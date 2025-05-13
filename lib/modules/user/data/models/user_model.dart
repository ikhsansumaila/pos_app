import 'package:hive/hive.dart';
import 'package:pos_app/core/storage/local_storage_service.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

part 'user_model.g.dart';

@HiveType(typeId: HiveTypeIds.user)
class UserModel extends HiveObject implements SyncableHiveObject<UserModel> {
  @HiveField(0)
  int id;

  @HiveField(1)
  int storeId;

  @HiveField(2)
  String? storeName;

  @HiveField(3)
  String nama;

  @HiveField(4)
  String email;

  @HiveField(5)
  int roleId;

  @HiveField(6)
  String role;

  @HiveField(7)
  int status;

  @HiveField(8)
  String createdAt;

  @HiveField(9)
  int cacheId;

  UserModel({
    required this.id,
    required this.storeId,
    this.storeName,
    required this.nama,
    required this.email,
    required this.roleId,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.cacheId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      storeId: json['store_id'],
      storeName: json['store_name'],
      nama: json['nama'],
      email: json['email'],
      roleId: json['role_id'],
      role: json['role'],
      status: json['status'],
      createdAt: json['created_at'],
      cacheId: json['cache_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'store_name': storeName,
      'nama': nama,
      'email': email,
      'role_id': roleId,
      'role': role,
      'status': status,
      'created_at': createdAt,
      'cache_id': cacheId,
    };
  }

  @override
  int? get modelId => cacheId;

  @override
  bool isDifferent(UserModel other) {
    return cacheId != other.cacheId ||
        storeId != other.storeId ||
        storeName != other.storeName ||
        nama != other.nama ||
        email != other.email ||
        roleId != other.roleId ||
        role != other.role ||
        status != other.status;
  }
}
