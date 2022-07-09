import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:makeup_webapp/ApiCalls/routes.dart';
import 'package:makeup_webapp/Model/User/UserModel/register_user_model/register_user_model.dart';

class LoginUserDB {
  //--singleton
  LoginUserDB._internal();
  static LoginUserDB instance = LoginUserDB._internal();
  factory() {
    return instance;
  }

  UserModel? userModel;
}

class AuthController {
  Future<http.Response?> loginUser(String email, String password) async {
    String url = Routes().baseUrl + Routes().login;
    // ignore: avoid_print
    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'email': email,
          'password': password,
        },
        headers: {
          "content-type": "application/x-www-form-urlencoded",
          "Access-Control-Allow-Origin": "*",
        },
        encoding: Encoding.getByName('utf-8'),
      );
      // ignore: avoid_print
      print('***************************');
      // ignore: avoid_print
      print('URL==== $url');
      // ignore: avoid_print
      print('___________________________');
      // ignore: avoid_print
      print('Http status code==== ${response.statusCode}');
      // ignore: avoid_print
      print('____________________________');
      // ignore: avoid_print
      print('Login response=====${response.body}');
      // ignore: avoid_print
      print('***************************');
      return response;
    } on Exception catch (e) {
      print("exception==$e");
    }
    return null;
  }

  Future<http.Response> registerUser(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    String url = Routes().baseUrl + Routes().signup;
    Map data = {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone
    };
    var response = await http.post(
      Uri.parse(url),
      body: json.encode(data),
      headers: {
        "content-type": "application/json",
        "Access-Control-Allow-Origin": "*"
      },
    );
    // ignore: avoid_print
    print('***************************');
    // ignore: avoid_print
    print('URL==== $url');
    // ignore: avoid_print
    print('___________________________');
    // ignore: avoid_print
    print('Http status code==== ${response.statusCode}');
    // ignore: avoid_print
    print('____________________________');
    // ignore: avoid_print
    print('signup response=====${json.decode(response.body)}');
    // ignore: avoid_print
    print('***************************');
    return response;
  }

  Future<http.Response> updateUser(
    String name,
    String phone,
  ) async {
    String url = Routes().baseUrl + Routes().updateProfile;
    Map data = {
      'id': LoginUserDB.instance.userModel!.id!,
      'name': name,
      'phone': phone
    };
    var response = await http.put(
      Uri.parse(url),
      body: json.encode(data),
      headers: {
        'Authorization': "Bearer ${LoginUserDB.instance.userModel?.token}",
        "content-type": "application/json",
        "Access-Control-Allow-Origin": "*"
      },
    );
    // ignore: avoid_print
    print('***************************');
    // ignore: avoid_print
    print('URL==== $url');
    // ignore: avoid_print
    print('___________________________');
    // ignore: avoid_print
    print('Http status code==== ${response.statusCode}');
    // ignore: avoid_print
    print('____________________________');
    // ignore: avoid_print
    print('update profile response=====${json.decode(response.body)}');
    // ignore: avoid_print
    print('***************************');
    return response;
  }
}
