import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'login.dart';
import 'tokeninfo.dart';
import 'userinfo.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => TokenInfo(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'flutter evaluation',
        home: MyPage());
  }
}

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "조민환 플러터평가",
          style: TextStyle(),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/pexels-photo-1624496.jpeg'),
                    fit: BoxFit.cover
                )
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                    MaterialPageRoute(builder: (context)=> Login()));
                  },
                  child: Text("로그인 페이지로 이동하려면 클릭하세요",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white
                  ),)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
