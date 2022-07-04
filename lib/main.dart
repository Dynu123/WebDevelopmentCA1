import 'package:flutter/material.dart';
import 'package:makeup_webapp/Model/User/UserModelResponse/user_model_response/user_model_response.dart';
import 'Screens/screen_home.dart';
import 'Screens/screen_login.dart';
import 'Screens/screen_signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.black),
      home:
          ScreenLogin(), //ProductItem(index: 0, name: 'lipstick', price: 'price'),
      routes: {
        "login": (ctx) {
          return ScreenLogin();
        },
        "signup": (ctx) {
          return ScreenSignup();
        },
        "home": (ctx) {
          return ScreenHome();
        }
      },
    );
  }
}
