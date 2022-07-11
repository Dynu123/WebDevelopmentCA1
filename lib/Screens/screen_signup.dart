import 'package:flutter/services.dart';
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

  String? _message = "";

  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool showPassword = false;
  bool showCPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: 400,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    cursorColor: Colors.black,
                    controller: _nameController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.person_rounded),
                        hintText: "Name",
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
                    cursorColor: Colors.black,
                    controller: _emailController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.email_rounded),
                        hintText: "Email",
                        border: OutlineInputBorder()),
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
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          icon: Icon(showPassword
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded),
                        ),
                        icon: const Icon(Icons.password_rounded),
                        hintText: "Enter password",
                        border: const OutlineInputBorder()),
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
                    obscureText: !showCPassword,
                    cursorColor: Colors.black,
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showCPassword = !showCPassword;
                            });
                          },
                          icon: Icon(showCPassword
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded),
                        ),
                        icon: const Icon(Icons.password_rounded),
                        hintText: "Confirm password",
                        border: const OutlineInputBorder()),
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
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    cursorColor: Colors.black,
                    controller: _phoneController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.phone_rounded),
                        hintText: "Phone",
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Field cannot be empty";
                      } else if (value.length != 10) {
                        return "Phone number should be 10 digits";
                      } else {
                        return null;
                      }
                    },
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

    if (_formKey.currentState!.validate()) {
      if (password == confirmPassword) {
        var response =
            await authController.registerUser(name, email, password, phone);
        var signUpResp = json.decode(response.body);
        if (response.statusCode == 200) {
          if (signUpResp['result']['code'] == '200') {
            var message = signUpResp['result']['message'];
            ScaffoldMessenger.of(_scaffoldKey.currentContext!)
                .showSnackBar(SnackBar(
              content: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color.fromARGB(255, 4, 134, 71),
            ));
            Navigator.of(_scaffoldKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (ctx) => const ScreenLogin()),
            );
          } else {
            var message = signUpResp['result']['message'];
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
          var message = signUpResp['result']['message'];
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
      } else {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
            .showSnackBar(const SnackBar(
          content: Text(
            "Confirm password does not match",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xB7D8382D),
        ));
      }
    } else {
      return;
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
