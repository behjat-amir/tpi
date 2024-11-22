import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tpi/data/auth_info.dart';

import '../../common/http_client.dart';
import '../source/auth_data_source.dart';

final authRepository = AuthRepository(AuthRemoteDataSource(httpClient));

abstract class IAuthRepository {
  Future<void> login(String username, String password);
  Future<void> setIsRememberMe(bool isRememberMe);
}

class AuthRepository implements IAuthRepository {
  final IAuthDataSource dataSource;
  static final ValueNotifier<AuthInfo?> authChangeNotifier =
      ValueNotifier(null);

  AuthRepository(this.dataSource);

  @override
  Future<void> login(String username, String password) async {
    final authInfo = await dataSource.login(username, password);
    _persistAuthTokens(authInfo);
  }

  Future<void> _persistAuthTokens(AuthInfo authInfo) async {
    const storage = FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true));
    await storage.write(key: 'name', value: authInfo.name);
    await storage.write(key: 'lastName', value: authInfo.lastname);
    await storage.write(key: 'mobile', value: authInfo.mobile);
    await storage.write(
        key: 'authorities', value: jsonEncode(authInfo.authorities));
    await storage.write(key: 'token', value: authInfo.token);
    loadAuthInfo();
  }

  Future<void> loadAuthInfo() async {
    const storage = FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));
    final String name = await storage.read(key: 'name') ?? '';
    final String lastName = await storage.read(key: 'lastName') ?? '';
    final String mobile = await storage.read(key: 'mobile') ?? '';
    final String authoritiesJson = await storage.read(key: 'authorities') ?? '';
    List<dynamic> authorities = List<dynamic>.from(jsonDecode(authoritiesJson));
    final String token = await storage.read(key: 'token') ?? '';
    if (name.isNotEmpty &&
        lastName.isNotEmpty &&
        mobile.isNotEmpty &&
        authorities.isNotEmpty &&
        token.isNotEmpty) {
      authChangeNotifier.value = AuthInfo(name, lastName, mobile, authorities, token);
    }
  }
  
  @override
  Future<void> setIsRememberMe(bool isRememberMe) async {
    const storage = FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));
    await storage.write(key: 'isRememberMe', value: isRememberMe.toString());
  }
}
