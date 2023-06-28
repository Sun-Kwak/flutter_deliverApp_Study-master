import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_deliverlyapp_test/common/component/custom_text_formfield.dart';
import 'package:flutter_deliverlyapp_test/common/const/colors.dart';
import 'package:flutter_deliverlyapp_test/common/const/data.dart';
import 'package:flutter_deliverlyapp_test/common/layout/default_layout.dart';
import 'package:flutter_deliverlyapp_test/common/secure_storage/secure_storage.dart';
import 'package:flutter_deliverlyapp_test/common/view/root_tab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String userName = '';
  String password = '';

  @override
  Widget build(BuildContext context) {

    final dio = Dio();



    return DefaultLayout(
      child: SafeArea(
        top: true,
        bottom: false,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _title(),
                const SizedBox(height: 16.0,),
                _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width / 3 * 2,
                ),
                const SizedBox(height: 16.0,),
                CustomTextFormField(
                  onChanged: (String value) {
                    userName = value;
                  },
                  hintText: '이메일 입력',
                  //errorText: '에러 발생',
                ),
                const SizedBox(height: 16.0,),
                CustomTextFormField(
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureText: true,
                  hintText: '비밀번호 입력',
                  //errorText: '에러 발생',
                ),
                const SizedBox(height: 16.0,),
                ElevatedButton(
                  onPressed: () async {
                    final rawString = '$userName:$password';

                    Codec<String, String> StringToBase64 = utf8.fuse(base64);

                    String token = StringToBase64.encode(rawString);

                    final resp = await dio.post(
                     'http://$ip/auth/login',
                      options: Options(
                        headers: {
                          'authorization': 'Basic $token',
                        }
                      ),
                    );

                    final refreshToken = resp.data['refreshToken'];
                    final accessToken = resp.data['accessToken'];

                    final storage = ref.read(secureStorageProvider);

                    await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
                    await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_)=> RootTab(), ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                  ),
                  child: Text(
                    '로그인',
                  ),
                ),
                TextButton(
                  onPressed: () async {

                  },
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _title extends StatelessWidget {
  const _title({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다.',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요!\n오늘도 행복한 하루 보내세요',
      style: TextStyle(
        fontSize: 16.0,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
