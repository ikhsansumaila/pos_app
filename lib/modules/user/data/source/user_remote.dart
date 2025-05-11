import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_app/core/network/dio_client.dart';
import 'package:pos_app/modules/user/data/models/user_create_model.dart';
import 'package:pos_app/modules/user/data/models/user_model.dart';
import 'package:pos_app/utils/constants/constant.dart';

class UserRemoteDataSource {
  final DioClient dio;
  UserRemoteDataSource(this.dio);

  Future<List<UserModel>> fetchUsers() async {
    final response = await dio.get(USER_API_URL);
    log('response.data ${response.data}');
    return (response.data as List).map((e) {
      Map<String, dynamic> map = e;
      log("map $map");
      return UserModel.fromJson(map);
    }).toList();
  }

  Future<Response> postUser(UserCreateModel user) async {
    return await dio.post(USER_API_URL, data: user.toJson());
  }

  //TODO: USE IT OR NOT?
  Future<void> postBulkUser(List<UserCreateModel> users) async {
    final data = jsonEncode(users.map((u) => u.toJson()).toList());
    await dio.post(USER_API_URL, data: data);
  }
}
