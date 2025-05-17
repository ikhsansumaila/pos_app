import 'package:hive/hive.dart';
import 'package:pos_app/modules/sync/service/local_storage_service.dart';
import 'package:pos_app/modules/transaction/selling/data/models/transaction_create_model.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: HiveTypeIds.transaction)
class TransactionModel extends HiveObject implements SyncableHiveObject<TransactionModel> {
  @HiveField(0)
  final int transId;

  @HiveField(1)
  final String transCode;

  @HiveField(2)
  final String transType;

  @HiveField(3)
  final String transDate;

  @HiveField(4)
  final double transTotal;

  @HiveField(5)
  final String createdAt;

  @HiveField(6)
  final int userId;

  TransactionModel({
    required this.transId,
    required this.transCode,
    required this.transType,
    required this.transDate,
    required this.transTotal,
    required this.createdAt,
    required this.userId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transId: json['trans_id'],
      transCode: json['trans_code'],
      transType: json['trans_type'],
      transDate: json['trans_date'],
      transTotal: (json['trans_total'] as num).toDouble(),
      createdAt: json['created_at'],
      userId: json['userid'],
    );
  }

  Map<String, dynamic> toJson() => {
    'trans_id': transId,
    'trans_code': transCode,
    'trans_type': transType,
    'trans_date': transDate,
    'trans_total': transTotal,
    'created_at': createdAt,
    'userid': userId,
  };

  factory TransactionModel.setByFormData(TransactionCreateModel trx) {
    return TransactionModel(
      transId: 0,
      transCode: '',
      transType: '',
      transDate: '',
      transTotal: 0,
      createdAt: '',
      userId: trx.userId,
    );
  }

  @override
  int get modelId => transId;

  @override
  bool isDifferent(TransactionModel other) {
    return transId != other.transId ||
        transCode != other.transCode ||
        transType != other.transType ||
        transDate != other.transDate ||
        transTotal != other.transTotal ||
        createdAt != other.createdAt ||
        userId != other.userId;
  }
}
