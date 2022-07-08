import 'dart:convert';

import 'package:flutter/material.dart';
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
                    Center(
                      child: CircleAvatar(
                        radius: 60,
                        child: Image.network(
                          "https://www.pngkey.com/png/full/115-1150152_default-profile-picture-avatar-png-green.png",
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
                      decoration: const InputDecoration(
                        hintText: "Enter phone number",
                      ),
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
                              child: const Text(
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
      var response = await authController.updateUser(name, phone);
      var signUpResp = json.decode(response.body);
      if (response.statusCode == 200) {
        if (signUpResp['result']['code'] == '200') {
          LoginUserDB.instance.userModel!.name = _nameController.text;
          LoginUserDB.instance.userModel!.phone = _phoneController.text;
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
