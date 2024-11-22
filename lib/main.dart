import 'dart:io';

import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:tpi/data/repo/auth_repository.dart';
import 'package:tpi/ui/auth/auth.dart';

import 'common/http_client.dart';
import 'theme.dart';

void configureHttpClient() {
  // بررسی کنید که httpClientAdapter از نوع IOHttpClientAdapter باشد
  if (httpClient.httpClientAdapter is IOHttpClientAdapter) {
    (httpClient.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      // غیرفعال کردن بررسی گواهی (برای محیط توسعه)
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        print('Warning: SSL verification bypassed for host: $host');
        return true;
      };
      return client;
    };
  }
}

void main() {
  configureHttpClient();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const defaultTextStyle = TextStyle(fontFamily: 'vazir');
    return MaterialApp(
      title: 'بازرسی ایمنی',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: LightThemeColors.primaryColor,
          onPrimary: Colors.white,
          secondary: LightThemeColors.secondaryColor,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: LightThemeColors.backgroundColor,
          onSurface: LightThemeColors.primaryTextColor,
        ),
        textTheme: TextTheme(
          titleLarge: defaultTextStyle.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          titleMedium: defaultTextStyle,
          titleSmall: defaultTextStyle,
          bodyLarge: defaultTextStyle,
          bodyMedium: defaultTextStyle,
          bodySmall: defaultTextStyle,
          labelLarge: defaultTextStyle,
          labelMedium: defaultTextStyle,
          labelSmall: defaultTextStyle,
        ),
        useMaterial3: true,
      ),
      home: AuthScreen(),
    );
  }
}
