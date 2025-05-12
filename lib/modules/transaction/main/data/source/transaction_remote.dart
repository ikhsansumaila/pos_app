// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:pos_app/core/network/dio_client.dart';
import 'package:pos_app/core/network/response.dart';
import 'package:pos_app/modules/transaction/main/data/models/transaction_create_model.dart';
import 'package:pos_app/modules/transaction/main/data/models/transaction_model.dart';
import 'package:pos_app/utils/constants/rest.dart';

class TransactionRemoteDataSource {
  final DioClient dio;
  final API_URL = TRANSACTION_API_URL;

  TransactionRemoteDataSource({required this.dio});

  Future<List<TransactionModel>> fetchTransaction() async {
    final response = await dio.get(API_URL);

    if (response.isSuccess) {
      log('response.data ${response.data}');
      return (response.data as List).map((e) {
        Map<String, dynamic> map = e;
        log("map $map");
        return TransactionModel.fromJson(map);
      }).toList();
    }

    return [];
  }

  Future<ApiResponse> postTransaction(TransactionCreateModel user) async {
    return await dio.post(API_URL, data: user.toJson());
  }

  //TODO: USE IT OR NOT?
  Future<void> postBulkUser(List<TransactionCreateModel> users) async {
    final data = jsonEncode(users.map((u) => u.toJson()).toList());
    await dio.post(API_URL, data: data);
  }
}
