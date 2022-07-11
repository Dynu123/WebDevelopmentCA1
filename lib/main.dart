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
      theme: ThemeData(
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black))),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
          ),
        ),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
        inputDecorationTheme: const InputDecorationTheme(
          iconColor: Colors.black,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
      home: ScreenLogin(),
      routes: {
        "login": (ctx) {
          return ScreenLogin();
        },
        "signup": (ctx) {
          return ScreenSignup();
        },
      }, //ProductItem
    );
  }
}
