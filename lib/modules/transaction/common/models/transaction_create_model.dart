import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:pos_app/utils/constants/hive_key.dart';

part 'transaction_create_model.g.dart';

@HiveType(typeId: HiveTypeIds.transactionCreate)
class TransactionCreateModel extends HiveObject {
  @HiveField(0)
  final int cacheId;

  @HiveField(1)
  final int storeId;

  @HiveField(2)
  final String transType;

  @HiveField(3)
  final String transDate;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final double transSubtotal;

  @HiveField(6)
  final double transDiscount;

  @HiveField(7)
  final double transTotal;

  @HiveField(8)
  final double transPayment;

  @HiveField(9)
  final double transBalance;

  @HiveField(10)
  final int userId;

  @HiveField(11)
  final List<TransactionItemModel> items;

  TransactionCreateModel({
    required this.cacheId,
    required this.storeId,
    required this.transType,
    required this.transDate,
    required this.description,
    required this.transSubtotal,
    required this.transDiscount,
    required this.transTotal,
    required this.transPayment,
    required this.transBalance,
    required this.userId,
    required this.items,
  });

  factory TransactionCreateModel.fromJson(Map<String, dynamic> json) {
    return TransactionCreateModel(
      cacheId: json['cache_id'],
      storeId: json['store_id'],
      transType: json['trans_type'],
      transDate: json['trans_date'],
      description: json['description'],
      transSubtotal: (json['trans_subtotal'] as num).toDouble(),
      transDiscount: (json['trans_discount'] as num).toDouble(),
      transTotal: (json['trans_total'] as num).toDouble(),
      transPayment: (json['trans_payment'] as num).toDouble(),
      transBalance: (json['trans_balance'] as num).toDouble(),
      userId: json['userid'],
      items: (json['items'] as List).map((item) => TransactionItemModel.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'cache_id': cacheId,
    'store_id': storeId,
    'trans_type': transType,
    'trans_date': transDate,
    'description': description,
    'trans_subtotal': transSubtotal,
    'trans_discount': transDiscount,
    'trans_total': transTotal,
    'trans_payment': transPayment,
    'trans_balance': transBalance,
    'userid': userId,
    'items': items.map((e) => e.toJson()).toList(),
  };

  toJsonObject() => jsonEncode(toJson());

  // Transaction Response detail :
  // {
  //   'trans_id': transId,       => n/a in detail
  //   'trans_code': transCode,   => n/a in detail
  //   'trans_type': transType,
  //   'trans_date': transDate,
  //   'trans_total': transTotal,
  //   'created_at': createdAt,   => n/a in detail
  //   'userid': userId,
  // };
}

@HiveType(typeId: HiveTypeIds.transactionItem)
class TransactionItemModel extends HiveObject {
  @HiveField(0)
  final int idBarang;

  @HiveField(1)
  final String kodeBarang;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int qty;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final double subtotal;

  @HiveField(6)
  final double discount;

  @HiveField(7)
  final double total;

  TransactionItemModel({
    required this.idBarang,
    required this.kodeBarang,
    required this.description,
    required this.qty,
    required this.price,
    required this.subtotal,
    required this.discount,
    required this.total,
  });

  factory TransactionItemModel.fromJson(Map<String, dynamic> json) {
    return TransactionItemModel(
      idBarang: json['id_brg'],
      kodeBarang: json['kode_brg'],
      description: json['description'],
      qty: json['qty'],
      price: (json['price'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id_brg': idBarang,
    'kode_brg': kodeBarang,
    'description': description,
    'qty': qty,
    'price': price,
    'subtotal': subtotal,
    'discount': discount,
    'total': total,
  };
}
