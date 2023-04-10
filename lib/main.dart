import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uniplat/login.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'NotoSansKR',
        ),
        home: LoginView());
  }
}

void ssssss() async {
  // トークンをヘッダーにセットする例
  String token = 'your_token_here';
  final dio = Dio();
  dio.interceptors.add(CookieManager(CookieJar()));
  dio.options.headers['Authorization'] = 'Bearer $token';

  try {
    // APIリクエストを送信し、レスポンスを受け取る
    final response = await dio.get('https://your-api-url.com/your-endpoint');

    // APIから取得したCookieを使用して処理を行う
    // 例えば、他のWebViewなどでCookieを使用する場合が考えられます
    // final cookieJar = dio.interceptors[0].cookieJar as CookieJar;
    final cookieJar = dio.interceptors[0] as CookieJar;

    final List<Cookie> cookies = await cookieJar.loadForRequest(Uri.parse('https://your-api-url.com'));

    // 取得したCookieを表示
    for (final cookie in cookies) {
      print('Cookie: ${cookie.name}=${cookie.value}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
