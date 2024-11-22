import 'package:dio/dio.dart';

final httpClient = Dio(
  BaseOptions(baseUrl: 'https://tpi.icicogroup.com/inspection/'),
);
