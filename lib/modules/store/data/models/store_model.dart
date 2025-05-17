import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:pos_app/modules/sync/service/local_storage_service.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

part 'store_model.g.dart';

@HiveType(typeId: HiveTypeIds.store)
class StoreModel extends HiveObject implements SyncableHiveObject<StoreModel> {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final int? cacheId;

  @HiveField(2)
  final String storeName;

  @HiveField(3)
  final String storeAddress;

  @HiveField(4)
  final String? createdAt;

  @HiveField(5)
  final String userId;

  @HiveField(6)
  final String? updatedAt;

  @HiveField(7)
  final String? updatedUserId;

  StoreModel({
    this.id,
    this.cacheId,
    required this.storeName,
    required this.storeAddress,
    this.createdAt,
    required this.userId,
    this.updatedAt,
    this.updatedUserId,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    log('fromJson : $json');
    // log("json['updated_at'].runtimeType: ${json['updated_at'].runtimeType}");
    return StoreModel(
      id: json['id'],
      storeName: json['store_name'],
      storeAddress: json['store_address'],
      createdAt: json['created_at'],
      userId: json['userid'],
      updatedAt: json['updated_at'],
      updatedUserId: json['updated_userid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_name': storeName,
      'store_address': storeAddress,
      'created_at': createdAt,
      'user_id': userId,
      'updated_at': updatedAt,
      'updated_user_id': updatedUserId,
    };
  }

  Map<String, dynamic> toJsonCreate() => {
    'store_name': storeName,
    'store_address': storeAddress,
    'user_id': userId,
  };

  @override
  String get modelId => id ?? 0.toString();

  @override
  bool isDifferent(StoreModel other) {
    return id != other.id ||
        storeName != other.storeName ||
        storeAddress != other.storeAddress ||
        createdAt != other.createdAt ||
        userId != other.userId ||
        updatedAt != other.updatedAt;
  }
}
