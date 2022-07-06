import 'package:makeup_webapp/ApiCalls/api_calls.dart';
import 'package:makeup_webapp/ApiCalls/auth_controller.dart';
import 'package:makeup_webapp/Model/User/UserModel/register_user_model/register_user_model.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:makeup_webapp/Screens/screen_login.dart';

class ScreenSignup extends StatefulWidget {
  ScreenSignup({Key? key}) : super(key: key);

  @override
  State<ScreenSignup> createState() => _ScreenSignupState();
}

class _ScreenSignupState extends State<ScreenSignup> {
  final _nameController = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  final _phoneController = TextEditingController();

  final _addressController = TextEditingController();

  String? _message = "";

  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool showErrorMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: 400,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        hintText: "Name", border: OutlineInputBorder()),
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
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                        hintText: "Email", border: OutlineInputBorder()),
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
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        hintText: "Enter password",
                        border: OutlineInputBorder()),
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
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                        hintText: "Confirm password",
                        border: OutlineInputBorder()),
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
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                        hintText: "Phone", border: OutlineInputBorder()),
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
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                        hintText: "Address", border: OutlineInputBorder()),
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
                      "Password and confirm password fields does not match!",
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
                        style: const TextStyle(
                          color: Colors.red,
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
                          onPressed: () {
                            //action
                            signupUser();
                          },
                          child: const Text("Sign up"))),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                          onPressed: () {
                            //action
                            Navigator.of(context).pushNamed("login");
                          },
                          child: const Text("Sign in"))
                    ],
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future signupUser() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final phone = _phoneController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    AuthController authController = AuthController();

    var response =
        await authController.registerUser(name, email, password, phone);
    var signUpResp = json.decode(response.body);
    if (response.statusCode == 200) {
      if (signUpResp['result']['code'] == '200') {
        var message = signUpResp['result']['message'];
        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
            .showSnackBar(SnackBar(content: Text(message)));
        Navigator.of(_scaffoldKey.currentContext!).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const ScreenLogin()),
        );
      } else {
        var message = signUpResp['result']['message'];
        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } else if (response.statusCode == 400) {
      var message = signUpResp['result']['message'];
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(message)));
    } else {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(response.body.toString())));
    }
  }

  Future signup(BuildContext context) async {
    final name = _nameController.text;
    final email = _emailController.text;
    final phone = _phoneController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    AuthController authController = AuthController();

    if (_formKey.currentState!.validate()) {
      final _newUser = UserModel.create(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      final newUser = await UserdDB().createUser(_newUser);
      if (newUser != null) {
        if (newUser.result?.code == "400") {
          setState(() {
            _message = newUser.result?.message;
          });
          return;
        }
        Navigator.of(_scaffoldKey.currentContext!).pop();
      } else {
        return; // result null
      }
    } else {
      return;
    }
  }
}
