import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:pos_app/core/storage/local_storage_service.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

part 'store_model.g.dart';

@HiveType(typeId: HiveTypeIds.store)
class StoreModel extends HiveObject implements SyncableHiveObject<StoreModel> {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String storeName;

  @HiveField(2)
  final String storeAddress;

  @HiveField(3)
  final String createdAt;

  @HiveField(4)
  final String userId;

  @HiveField(5)
  final String? updatedAt;

  @HiveField(6)
  final String updatedUserId;

  StoreModel({
    required this.id,
    required this.storeName,
    required this.storeAddress,
    required this.createdAt,
    required this.userId,
    this.updatedAt,
    required this.updatedUserId,
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

  @override
  String get modelId => id;

  @override
  bool isDifferent(StoreModel other) {
    return id != other.id ||
        storeName != other.storeName ||
        storeAddress != other.storeAddress ||
        createdAt != other.createdAt ||
        userId != other.userId ||
        updatedAt != other.updatedAt ||
        updatedUserId != other.updatedUserId;
  }
}
