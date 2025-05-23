import 'package:pos_app/core/network/dio_client.dart';
import 'package:pos_app/core/network/response.dart';

class AuthRepository {
  final DioClient dio;
  AuthRepository(this.dio);
  Future<ApiResponse> login(Map<String, dynamic> data) async {
    return await dio.request(
      path: '/api/auth',
      method: AppHttpMethod.post,
      data: data,
      showLoading: true,
    );
  }
}
