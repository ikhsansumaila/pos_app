import 'package:hive/hive.dart';
import 'package:pos_app/core/services/sync/sync_api_service.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject implements SyncableHiveObject<User> {
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

  User({
    required this.id,
    required this.storeId,
    this.storeName,
    required this.nama,
    required this.email,
    required this.roleId,
    required this.role,
    required this.status,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      storeId: json['store_id'],
      storeName: json['store_name'],
      nama: json['nama'],
      email: json['email'],
      roleId: json['role_id'],
      role: json['role'],
      status: json['status'],
      createdAt: json['created_at'],
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
    };
  }

  @override
  int get modelId => id;

  @override
  bool isDifferent(User other) {
    return storeId != other.storeId ||
        storeName != other.storeName ||
        nama != other.nama ||
        email != other.email ||
        roleId != other.roleId ||
        role != other.role ||
        status != other.status ||
        createdAt != other.createdAt;
  }
}
