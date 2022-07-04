import 'package:makeup_webapp/ApiCalls/api_calls.dart';
import 'package:makeup_webapp/ApiCalls/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:makeup_webapp/Model/User/UserModel/register_user_model/register_user_model.dart';
import 'package:makeup_webapp/Screens/screen_home.dart';
import 'package:makeup_webapp/Screens/screen_list_expense.dart';

class ScreenLogin extends StatefulWidget {
  ScreenLogin({Key? key}) : super(key: key);

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
        backgroundColor: Colors.blueGrey,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
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
                        controller: _emailController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter username"),
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
                        obscureText: true,
                        decoration: const InputDecoration(
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
                              onPressed: () {
                                //action
                                if (_formKey.currentState!.validate()) {
                                  login(context);
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
          Navigator.of(_scaffoldKey.currentContext!).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => const ScreenListExpense(
                title: "Trip to howth",
                amount: "euro 140",
                transactionType: TransactionType.income,
                note:
                    "It was a wonderful tripto howth and we spent a total of euro 140 altogether",
                transactionDate: "06-04-2022",
              ),
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
