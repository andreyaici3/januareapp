import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late List<Widget> tabChildren;
  int currentIndex = 0;

  Widget page1() {
    return Center(
      child: Container(
        child: Text("Page1"),
      ),
    );
  }

  Widget page2() {
    return Center(
      child: Container(
        child: Text("Page2"),
      ),
    );
  }

  Widget page3() {
    return Center(
      child: Container(
        child: Text("Page3"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
