import 'package:makeup_webapp/ApiCalls/api_calls.dart';
import 'package:makeup_webapp/ApiCalls/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:makeup_webapp/Model/User/UserModel/register_user_model/register_user_model.dart';
import 'package:makeup_webapp/Model/User/UserModelResponse/user_model_response/user_model_response.dart';
import 'package:makeup_webapp/Screens/screen_list_expense.dart';
import 'dart:convert';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({Key? key}) : super(key: key);

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showErrorMessage = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _message = "";
  Color? _messageColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              height: 385,
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        cursorColor: Colors.black,
                        controller: _emailController,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.email_rounded),
                            border: OutlineInputBorder(),
                            hintText: "Enter username"),
                        validator: (value) {
                          bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value ?? "");
                          if (value == null || value.isEmpty) {
                            return "Field cannot be empty";
                          } else if (!emailValid) {
                            return "Email is not valid";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        cursorColor: Colors.black,
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.password_rounded),
                            border: OutlineInputBorder(),
                            hintText: "Enter password"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Field cannot be empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: showErrorMessage,
                        child: const Text(
                          "Username and password does not match!",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            _message!,
                            style: TextStyle(
                              color: _messageColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                              // ignore: prefer_const_constructors
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black),
                              onPressed: () {
                                //action
                                if (_formKey.currentState!.validate()) {
                                  loginUser();
                                } else {
                                  print("no data");
                                }
                                ;
                              },
                              child: const Text("Login"))),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Text("Don't have an account yet?"),
                          TextButton(
                              style:
                                  TextButton.styleFrom(primary: Colors.black),
                              onPressed: () {
                                //action
                                Navigator.of(context).pushNamed("signup");
                              },
                              child: const Text("Sign up"))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> loginUser() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    AuthController authController = AuthController();

    var response = await authController.loginUser(email, password);
    if (response != null) {
      var loginResp = json.decode(response.body);
      if (response.statusCode == 200) {
        if (loginResp['result']['code'] == '200') {
          LoginUserDB.instance.userModel =
              UserModel.fromJson(loginResp['result']['data']);
          Navigator.of(_scaffoldKey.currentContext!).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => const ScreenListExpense(),
            ),
          );
        } else {
          var message = loginResp['result']['message'];
          ScaffoldMessenger.of(_scaffoldKey.currentContext!)
              .showSnackBar(SnackBar(
            content: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xB7D8382D),
          ));
        }
      } else if (response.statusCode == 400) {
        var message = loginResp['result']['message'];
        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
            .showSnackBar(SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xB7D8382D),
        ));
      } else {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
            .showSnackBar(SnackBar(
          content: Text(
            response.body.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xB7D8382D),
        ));
      }
    }
  }

  Future<void> login(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;
    AuthController authController = AuthController();

    if (_formKey.currentState!.validate()) {
      final _userModel = UserModel.create(
        name: "",
        email: email,
        password: password,
        phone: "",
      );
      final user = await UserdDB().login(_userModel);
      if (user != null) {
        if (user.result?.code == "400") {
          setState(() {
            _message = user.result?.message;
            _messageColor = Colors.red;
          });
          return;
        } else if (user.result?.code != "200") {
          setState(() {
            _message = "Some error occured = ${user.result?.code}";
            _messageColor = Colors.red;
          });
          return;
        }
        if (!mounted) return;
        setState(() {
          _message = user.result?.message;
          _messageColor = Colors.green;
          UserModelResponse.instance.result?.userModel = user.result?.userModel;
          print(
              "*******user id = ${UserModelResponse.instance.result?.userModel?.id}");
          Navigator.of(_scaffoldKey.currentContext!).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => ScreenListExpense(),
            ),
          );
        });
      } else {
        return; //result null
      }
    } else {
      return;
    }
  }
}
