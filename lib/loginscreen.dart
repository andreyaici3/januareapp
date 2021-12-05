import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:januareapp1/const.dart';
import 'package:januareapp1/model/userModel.dart';
import 'package:januareapp1/registerscreen.dart';
import 'dart:async';

import 'package:januareapp1/seller/homepageseller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late double width, height;
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final TextEditingController email = TextEditingController();
  final TextEditingController passw = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;
  bool loading = false;
  List<UserModel> list = [];

  void checkLogin() {}

  void showsDialog(String titles, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(titles),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Ok",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  String? validatePassword(String value) {
    // String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  login() async {
    try {
      setState(() {
        loading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await http.post(Uri.parse(baseUrl + "?dest=user"), body: {
        'email': email.text,
        'pass': passw.text,
      });
      final getData = jsonDecode(response.body);
      getData["tambahan"] = jsonEncode(getData["data"]);
      final List<UserModel> a = userModelFromJson(getData["tambahan"]);
      print(a[0].email);
      if (getData["status"]) {
        if (isChecked) {
          prefs.setBool("login", true);
          prefs.setString("email", a[0].email);
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => HomePageSeller(
              um: a,
            ),
          ),
        );
      } else {
        showsDialog("Login Failed", "Check your credentials");
      }
    } catch (e) {
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: height / 2,
            width: width,
            child: Image.asset(
              'assets/images/loginBg.png',
              fit: BoxFit.cover,
            ),
          ),
          //container
          Container(
            height: 600,
            margin: EdgeInsets.only(top: height / 3),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    elevation: 10,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(25, 10, 20, 25),
                      child: Form(
                        child: Column(
                          children: [
                            const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: email,
                              focusNode: focus,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (value) => value!.isEmpty ||
                                      !value.contains("@") ||
                                      !value.contains(".")
                                  ? "Enter a valid Email"
                                  : null,
                              onFieldSubmitted: (value) =>
                                  FocusScope.of(context).requestFocus(focus1),
                              decoration: const InputDecoration(
                                labelText: "Email",
                                icon: Icon(
                                  Icons.mail,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ),
                              ),
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: passw,
                              textInputAction: TextInputAction.done,
                              focusNode: focus1,
                              decoration: const InputDecoration(
                                labelText: "Password",
                                icon: Icon(Icons.lock),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ),
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? "Enter a Password" : null,
                              onFieldSubmitted: (value) =>
                                  FocusScope.of(context).requestFocus(focus2),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isChecked = !isChecked;
                                    });
                                  },
                                ),
                                const Flexible(
                                  child: Text(
                                    "Remember Me",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: Size(width / 3, 50)),
                                  child: const Text('Login'),
                                  onPressed: login,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Register New Account? ",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      GestureDetector(
                        child: const Text(
                          " Click Here",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => RegisterScreen()));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Forgot password? ",
                          style: TextStyle(fontSize: 16.0)),
                      GestureDetector(
                        onTap: null,
                        child: const Text(
                          " Click here",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          loading
              ? Container(
                  width: width,
                  height: height,
                  color: Colors.white.withOpacity(0.8),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Please Wait"),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
