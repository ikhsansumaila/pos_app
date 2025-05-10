import 'dart:developer';

import 'package:pos_app/core/network/dio_client.dart';
import 'package:pos_app/modules/user/data/models/user_model.dart';
import 'package:pos_app/utils/constants/constant.dart';

class UserRemoteDataSource {
  final DioClient dio;
  UserRemoteDataSource(this.dio);

  Future<List<User>> fetchUsers() async {
    final response = await dio.get(USER_API_URL);
    log('response.data ${response.data}');
    return (response.data as List).map((e) {
      Map<String, dynamic> map = e;
      log("map $map");
      return User.fromJson(map);
    }).toList();
  }

  Future<void> postUser(User user) async {
    await dio.post(USER_API_URL, data: user.toJson());
  }
}
