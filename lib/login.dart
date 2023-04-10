import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gradient_like_css/gradient_like_css.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniplat/common_web_view.dart';
import 'package:uniplat/constants/colors.dart';
import 'package:uniplat/home_view.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:uniplat/open_browser.dart';
import 'constants/urls.dart';

final isLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);
final isLoginProvider = StateProvider.autoDispose<bool>((ref) => false);
final tokenProvider = StateProvider<String>((ref) => "");

class LoginView extends HookConsumerWidget {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  CookieManager cookieManager = CookieManager.instance();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(backgroundColor: ConstantsColors.mainColor),
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                // color: Colors.white,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background_image.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: 524,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(35, 50, 35, 35),
                      child: SingleChildScrollView(
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.bottomLeft,
                                child: const Text(
                                  "Sign in to UNIPLAT",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(
                                height: 36,
                              ),
                              formBox(
                                  "Email",
                                  "Your email",
                                  "assets/images/icon-email.png",
                                  emailTextController),
                              const SizedBox(
                                height: 8,
                              ),
                              formBox(
                                  "Password",
                                  "Your password",
                                  "assets/images/icon-password.png",
                                  passwordTextController,
                                  obscure: true),
                              const SizedBox(
                                height: 28,
                              ),
                              Container(
                                width: double.infinity,
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: linearGradient(90.95, [
                                    '#4386C7 0.19%',
                                    '#DB5C6C 49.57%',
                                    '#F4BD1C 100%'
                                  ]),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(66, 136, 198, 0.15),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                    ),
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        final email = emailTextController.text;
                                        final password =
                                            passwordTextController.text;
                                        await login(
                                            context, ref, email, password);
                                      }
                                    },
                                    child: const Text(
                                      "Log In",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    )),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account?",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  TextButton(
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.zero),
                                        minimumSize: MaterialStateProperty.all(
                                            Size.zero),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () {
                                        openBrowser(getUrl(Urls.signUp));
                                      },
                                      child: Text(
                                        "Sign Up?",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: ConstantsColors
                                                .signUpTextColor),
                                      )),
                                ],
                              ),
                              Text("/"),
                              // Text("Forgot password?"),
                              TextButton(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.zero),
                                    minimumSize:
                                        MaterialStateProperty.all(Size.zero),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    openBrowser(getUrl(Urls.forgotPassword));
                                  },
                                  child: Text(
                                    "Forgot password?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  )),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                "*Please log in to view contents",
                                style: TextStyle(
                                    color: ConstantsColors
                                        .forgotPasswordTextColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ref.watch(isLoadingProvider)
                  ? Container(
                      color: Color.fromRGBO(97, 97, 97, 0.4),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Container()
            ],
          ),
        ),
      ],
    );
  }

  Widget formBox(String title, String hint, String icon,
      TextEditingController textController,
      {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              color: ConstantsColors.loginTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          obscureText: obscure,
          controller: textController,
          cursorColor: Colors.black,
          validator: (value) {
            if (obscure) {
              final passwordPattern =
                  RegExp(r'^(?=.*[A-Z])(?=.*\d)[a-zA-Z\d$@$!%*#?&^()~]{8,}$');
              if (value == null ||
                  value.isEmpty ||
                  !passwordPattern.hasMatch(value)) {
                return 'Please enter a valid password';
              }
            } else {
              if (value == null || value.isEmpty || !value.contains('@')) {
                return 'Please enter a valid email address';
              }
            }

            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 16.0,
              color: ConstantsColors.loginHintTextColor,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: ConstantsColors.loginHintTextColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            fillColor: Colors.white,
            filled: true,
            isDense: true,
            suffixIcon: Image(image: AssetImage(icon)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: ConstantsColors.loginHintTextColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> login(BuildContext context, WidgetRef ref, String email,
      String password) async {
    final prefs = await SharedPreferences.getInstance();
    var cookiesNames = prefs.getKeys();

    print(prefs.getKeys());
    if (cookiesNames.isEmpty) {
      print("存在しない"); // API URLを設定
      final Uri apiUrl = Uri.parse(getUrl(Urls.apiLogin));

      // http.MultipartRequestを作成
      http.MultipartRequest request = http.MultipartRequest('POST', apiUrl);

      // フォームデータを追加
      request.fields['email'] = "psv@daum.net";
      request.fields['password'] = "1111";

      // リクエストを送信
      http.StreamedResponse response = await request.send();

      // 応答を確認
      if (response.statusCode == 200) {
        // 成功した場合、レスポンスを読み取り
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

        // JSONオブジェクトから特定の値を取得
        var myValue = jsonResponse['key'];
        var myValue2 = jsonResponse['token'];

        // 値を使用して必要な操作を実行
        print("Value: $myValue");
        print("Value: $myValue2");

        print("Response: $responseBody");
        print("token: ${jsonResponse['token']}");
        ref.read(tokenProvider.notifier).state = jsonResponse['token'];

        print("aa");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return HomeView(
                isLogin: false,
              );
            },
          ),
        );
      } else {
        // エラーが発生した場合、エラーメッセージを表示
        print("Error: ${response.reasonPhrase}");
        AwesomeDialog(
          context: context,
          dialogType: DialogType.noHeader,
          animType: AnimType.scale,
          headerAnimationLoop: false,
          title: 'Error',
          desc: response.reasonPhrase,
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.orange,
        )..show();
      }
    } else {
      print("存在する");
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return HomeView(
              isLogin: true,
            );
          },
        ),
      );
    }
  }
}
