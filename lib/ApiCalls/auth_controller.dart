import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:makeup_webapp/ApiCalls/routes.dart';

class AuthController {
  Future loginUser(String email, String password) async {
    String url = Routes().baseUrl + Routes().login;
    var response = await http.post(
      Uri.parse(url),
      body: {
        'email': email,
        'password': password,
      },
      encoding: Encoding.getByName('utf-8'),
    );
    if (response.statusCode == 200) {
      var loginResp = json.decode(response.body);
      var token = loginResp['result']['data']['token'];
      print("loginresp == $token");
    } else {
      print("login error");
    }
  }

  Future registerUser(String name, String email, String password,
      String confirmPassword, String phone) async {
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
      headers: {"content-type": "application/json"},
    );
    var statusCode = response.body;
    if (response.statusCode == 200) {
      var registerResp = json.decode(response.body);
    } else {}
  }
}
