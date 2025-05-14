import 'dart:developer';

import 'package:pos_app/core/network/dio_client.dart';
import 'package:pos_app/modules/store/data/models/store_model.dart';
import 'package:pos_app/utils/constants/rest.dart';

class StoreRemoteDataSource {
  final DioClient dio;
  StoreRemoteDataSource({required this.dio});

  Future<List<StoreModel>> fetchStores() async {
    final response = await dio.get(STORE_API_URL);

    if (response.isSuccess && response.data is List) {
      return (response.data as List).map((e) {
        Map<String, dynamic> map = e;
        log("map data store $map");
        return StoreModel.fromJson(map);
      }).toList();
    }
    return [];
  }
}
