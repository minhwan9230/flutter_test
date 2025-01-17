import 'package:flutter/material.dart';
import 'package:flutter_evaluation/detail.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'tokeninfo.dart';
import 'userinfo.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController nameCtlor = TextEditingController();
  final TextEditingController passwordCtlor = TextEditingController();
  UserInfo? userInfo;

  String? responseError;
  bool isLoggedIn = false;

  Future<void> loginRequest(BuildContext context) async {
    TokenInfo provider = context.read<TokenInfo>();
    final url = Uri.parse("http://10.0.2.2:8080/api/login");
    final body = userInfo!.toJson();

    try {
      final response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        setState(() {
          isLoggedIn = true;
        });
        final refresh = response.headers['set-cookie'];
        final access = response.headers['authorization'];
        provider.saveAccessToken(access);
        provider.saveRefreshToken(refresh);
      } else if (response.statusCode == 401) {
        responseError = utf8.decode(response.bodyBytes); // 로그인 실패 메시지
      } else {
        setState(() {
          responseError = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      responseError = 'Error: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LoginPage"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/pexels-photo-1624496.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameCtlor,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    TextField(
                      controller: passwordCtlor,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                      obscureText: true, // 비밀번호 입력 시 숨기기
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white10,
                        elevation: 0,
                        minimumSize: const Size(100, 50),
                      ),
                      onPressed: () {
                        setState(() {
                          userInfo = UserInfo(
                            username: nameCtlor.text,
                            password: passwordCtlor.text,
                          );
                        });

                        loginRequest(context).then((_) {
                          if (isLoggedIn) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Detail(),
                              ),
                            );
                          } else {
                            showSnackBar(context, responseError ?? "로그인 실패");
                          }
                        });
                      },
                      child: const Text(
                        "로그인",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showSnackBar(BuildContext context, String str) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        str,
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.blue,
    ),
  );
}
