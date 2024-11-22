import 'package:dio/dio.dart';
import 'package:tpi/common/utils.dart';
import 'package:tpi/data/auth_info.dart';
import 'package:tpi/data/common/http_response_validator.dart';

abstract class IAuthDataSource {
  Future<AuthInfo> login(String username, String password);
}

class AuthRemoteDataSource
    with HttpResponseValidator
    implements IAuthDataSource {
  final Dio httpClient;

  AuthRemoteDataSource(this.httpClient);

  @override
  Future<AuthInfo> login(String username, String password) async {
    final response = await httpClient.post(
      'auth',
      data: {
        'username': username,
        'password': encryptString(text: password),
      },
    );
    validateResponse(response);
    return AuthInfo(
      response.data['data']['user']['name'],
      response.data['data']['user']['lastName'],
      response.data['data']['user']['mobile'],
      response.data['data']['user']['authorities'],
      response.data['data']['token'],
    );
  }
}

