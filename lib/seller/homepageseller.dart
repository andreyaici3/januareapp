import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:januareapp1/model/productmodel.dart';
import 'package:januareapp1/model/productmodel1.dart';
import 'package:januareapp1/model/userModel.dart';
import 'package:januareapp1/profile.dart';
import 'package:januareapp1/seller/page1seller.dart';
import 'package:januareapp1/const.dart';
import 'package:http/http.dart' as http;

class HomePageSeller extends StatefulWidget {
  final List<UserModel> um;
  const HomePageSeller({Key? key, required this.um}) : super(key: key);

  @override
  _HomePageSellerState createState() => _HomePageSellerState();
}

class _HomePageSellerState extends State<HomePageSeller> {
  late List<Widget> tabChildren;
  List<ProducModel> list = [];

  bool loading = false;
  List b = [];

  int currentIndex = 0;
  String maintitle = "Home";

  getData() async {
    try {
      setState(() {
        loading = true;
      });
      var response = await http.get(
        Uri.parse(baseUrl + "?dest=product"),
      );
      final getData = jsonDecode(response.body);
      b.addAll(getData["data"]);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    tabChildren = [
      Page1Seller(
        product: b,
      ),
      Profile(
        ums: widget.um,
      ),
    ];
    getData();
  }

  Widget page2() {
    return Center(
      child: Container(
        child: Text("Page2"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading ? CircularProgressIndicator() : tabChildren[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}

class ProducModel {}
