import 'package:pos_app/core/network/dio_client.dart';
import 'package:pos_app/core/network/response.dart';
import 'package:pos_app/modules/user/data/models/user_model.dart';
import 'package:pos_app/modules/user/data/models/user_role_model.dart';
import 'package:pos_app/utils/constants/rest.dart';

class UserRemoteDataSource {
  final DioClient dio;
  UserRemoteDataSource({required this.dio});

  Future<List<UserModel>> fetchUsers() async {
    final response = await dio.request(path: USER_API_URL, method: AppHttpMethod.get);

    if (response.isSuccess && response.data is List) {
      return (response.data as List).map((e) {
        Map<String, dynamic> map = e;
        // log("map data user : $map");
        return UserModel.fromJson(map);
      }).toList();
    }
    return [];
  }

  Future<ApiResponse> postUser(Map<String, dynamic> data) async {
    return await dio.request(path: USER_API_URL, method: AppHttpMethod.post, data: data);
  }

  Future<List<UserRoleModel>> fetchUserRoles() async {
    final response = await dio.request(path: USER_ROLES_API_URL, method: AppHttpMethod.get);

    if (response.isSuccess && response.data is List) {
      return (response.data as List).map((e) {
        Map<String, dynamic> map = e;
        // log("map data user role : $map");
        return UserRoleModel.fromJson(map);
      }).toList();
    }
    return [];
  }
}
