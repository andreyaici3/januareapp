import 'package:flutter/material.dart';
import 'package:januareapp1/const.dart';
import 'package:januareapp1/dashboard.dart';
import 'package:januareapp1/loginscreen.dart';
import 'package:januareapp1/model/userModel.dart';
import 'package:januareapp1/seller/homepageseller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  List<UserModel> a = [];
  checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool("login") != null) {
      getProfile();
      dash();
    } else {
      splash();
    }
  }

  splash() async {
    var jeda = Duration(seconds: 3);
    return Timer(jeda, () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  }

  getProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await http.post(Uri.parse(baseUrl + "?dest=user"), body: {
        'email': prefs.getString(("email")),
        'pass': "Joya_123",
      });
      final getData = jsonDecode(response.body);
      getData["tambahan"] = jsonEncode(getData["data"]);
      a = userModelFromJson(getData["tambahan"]);
    } catch (e) {}
  }

  dash() async {
    var jeda = Duration(seconds: 3);

    return Timer(jeda, () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => HomePageSeller(
                um: a,
              )));
    });
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Pattern.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Januare App",
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CircularProgressIndicator(),
                Text(
                  "Version 1.0",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
