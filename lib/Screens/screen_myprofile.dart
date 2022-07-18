import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makeup_webapp/ApiCalls/auth_controller.dart';

class ScreenProfile extends StatefulWidget {
  const ScreenProfile({Key? key}) : super(key: key);

  @override
  State<ScreenProfile> createState() => _ScreenProfileState();
}

class _ScreenProfileState extends State<ScreenProfile> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool readOnly = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @protected
  @mustCallSuper
  @override
  void initState() {
    _nameController.text = LoginUserDB.instance.userModel!.name!;
    _emailController.text = LoginUserDB.instance.userModel!.email!;
    _phoneController.text = LoginUserDB.instance.userModel!.phone!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: 
        TextButton(onPressed: (){
          Navigator.of(context).pop();
        }, child: const Text("Go to home page", style: TextStyle(color: Colors.white,),),),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          height: 600,
          width: 500,
          child: Card(
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Visibility(
                        visible: readOnly,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              readOnly = !readOnly;
                            });
                          },
                          icon: const Icon(Icons.edit_rounded),
                        ),
                      ),
                    ),
                    const Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage(
                          "assets/images/avatar.jpeg",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Name",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      readOnly: readOnly,
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: "Enter name",
                      ),
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
                    const Text(
                      "Email address",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: "Enter email",
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Phone",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      readOnly: readOnly,
                      controller: _phoneController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        hintText: "Enter phone number",
                      ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: !readOnly,
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                //cancel edit
                                setState(() {
                                  readOnly = !readOnly;
                                  _nameController.text =
                                      LoginUserDB.instance.userModel!.name!;
                                  _emailController.text =
                                      LoginUserDB.instance.userModel!.email!;
                                  _phoneController.text =
                                      LoginUserDB.instance.userModel!.phone!;
                                });
                              },
                              child: const Text(
                                "Cancel",
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: !readOnly,
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                //update profile

                                updateProfle();
                              },
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    )
                                  : const Text(
                                      "Update",
                                    ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future updateProfle() async {
    final name = _nameController.text;
    final phone = _phoneController.text;
    AuthController authController = AuthController();

    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = !isLoading;
      });
      var response = await authController.updateUser(name, phone);
      setState(() {
        isLoading = !isLoading;
      });
      var signUpResp = json.decode(response.body);
      if (response.statusCode == 200) {
        if (signUpResp['result']['code'] == '200') {
          setState(() {
            LoginUserDB.instance.userModel!.name = _nameController.text;
            LoginUserDB.instance.userModel!.phone = _phoneController.text;
          });

          var message = signUpResp['result']['message'];
          ScaffoldMessenger.of(_scaffoldKey.currentContext!)
              .showSnackBar(SnackBar(
            content: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromARGB(255, 4, 134, 71),
          ));
          Navigator.of(_scaffoldKey.currentContext!).pop();
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
      return;
    }
  }
}
