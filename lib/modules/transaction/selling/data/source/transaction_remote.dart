// ignore_for_file: non_constant_identifier_names

import 'package:pos_app/core/network/dio_client.dart';
import 'package:pos_app/core/network/response.dart';
import 'package:pos_app/modules/transaction/common/models/transaction_model.dart';
import 'package:pos_app/utils/constants/rest.dart';

class TransactionRemoteDataSource {
  final DioClient dio;
  final API_URL = TRANSACTION_API_URL;

  TransactionRemoteDataSource({required this.dio});

  Future<List<TransactionModel>> fetchTransaction() async {
    final response = await dio.request(path: API_URL, method: AppHttpMethod.get);

    if (response.isSuccess) {
      // log('response.data ${response.data}');
      return (response.data as List).map((e) {
        Map<String, dynamic> map = e;
        // log("map $map");
        return TransactionModel.fromJson(map);
      }).toList();
    }

    return [];
  }

  Future<ApiResponse> postTransaction(Map<String, dynamic> data) async {
    return await dio.request(
      path: API_URL,
      method: AppHttpMethod.post,
      data: data,
      showLoading: true,
    );
  }

  //TODO: USE IT OR NOT?
  // Future<void> postBulkTransaction(List<TransactionCreateModel> trx) async {
  //   final data = jsonEncode(trx.map((u) => u.toJson()).toList());
  //   await dio.post(API_URL, data: data);

  // }
}
