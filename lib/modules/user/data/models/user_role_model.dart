import 'package:hive/hive.dart';
import 'package:pos_app/modules/sync/service/local_storage_service.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

part 'user_role_model.g.dart';

@HiveType(typeId: HiveTypeIds.userRole)
class UserRoleModel extends HiveObject implements SyncableHiveObject<UserRoleModel> {
  @HiveField(0)
  int id;

  @HiveField(1)
  String role;

  UserRoleModel({required this.id, required this.role});

  factory UserRoleModel.fromJson(Map<String, dynamic> json) {
    return UserRoleModel(id: json['id'], role: json['role']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'role': role};
  }

  @override
  int get modelId => id;

  @override
  bool isDifferent(UserRoleModel other) {
    return id != other.id || role != other.role;
  }
}
