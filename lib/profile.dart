import 'package:flutter/material.dart';
import 'package:januareapp1/model/userModel.dart';
import 'package:januareapp1/splashpage.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  List<UserModel> ums;
  Profile({Key? key, required this.ums}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("login");
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => SplashPage()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(
          top: 10.0,
          left: 10,
          right: 10,
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Card(
                color: Colors.blue,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Nama: " + widget.ums[0].name),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("Email: " + widget.ums[0].email),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("Phone Number: " + widget.ums[0].phone),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("Registered At: " + widget.ums[0].phone),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("Address: " + widget.ums[0].address),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: logout,
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
