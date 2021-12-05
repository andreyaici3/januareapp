import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:januareapp1/const.dart';
import 'package:januareapp1/loginscreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late double width, height;
  bool isChecked = false;
  bool isVisible = false;
  bool loading = false;
  bool isAgree = false;

  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController pass1 = TextEditingController();
  final TextEditingController pass2 = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String eula = "";

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          _buildBg(),
          _buildForm(),
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

  Widget _buildBg() {
    return Container(
      height: height / 2,
      color: Colors.red,
      child: Image.asset(
        'assets/images/loginBg.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      height: height / 1.5,
      width: width,
      margin: EdgeInsets.only(top: height / 5),
      padding: const EdgeInsets.only(
        left: 20,
        right: 10,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 10,
              child: Form(
                key: formKey,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(25, 10, 20, 25),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Register New Account",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: name,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.newline,
                        decoration: const InputDecoration(
                          labelText: "Name",
                          icon: Icon(Icons.person),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 0.5),
                          ),
                        ),
                        onFieldSubmitted: (value) =>
                            FocusScope.of(context).requestFocus(focus),
                        validator: (value) =>
                            value!.isEmpty || (value.length < 3)
                                ? "Name must be longer than 3"
                                : null,
                      ),
                      TextFormField(
                        controller: email,
                        textInputAction: TextInputAction.next,
                        focusNode: focus,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.mail),
                          labelText: "Email",
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 0.5),
                          ),
                        ),
                        onFieldSubmitted: (value) =>
                            FocusScope.of(context).requestFocus(focus1),
                        validator: (value) => value!.isEmpty ||
                                !value.contains("@") ||
                                !value.contains(".")
                            ? "Enter a valid email"
                            : null,
                      ),
                      TextFormField(
                        controller: pass1,
                        textInputAction: TextInputAction.next,
                        focusNode: focus1,
                        onFieldSubmitted: (value) =>
                            FocusScope.of(context).requestFocus(focus2),
                        decoration: InputDecoration(
                          labelText: "Password",
                          icon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            icon: Icon(
                              isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width: 0.5),
                          ),
                        ),
                        validator: (value) =>
                            validatePassword(value.toString()),
                        obscureText: isVisible,
                      ),
                      TextFormField(
                        style: const TextStyle(),
                        textInputAction: TextInputAction.done,
                        focusNode: focus2,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus3);
                        },
                        controller: pass2,
                        decoration: InputDecoration(
                          labelText: 'Re-enter Password',
                          labelStyle: const TextStyle(),
                          icon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width: 0.5),
                          ),
                        ),
                        obscureText: isVisible,
                        validator: (val) {
                          validatePassword(val.toString());
                          if (val != pass1.text) {
                            return "password do not match";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                            Flexible(
                              child: GestureDetector(
                                onTap: _showEULA,
                                child: const Text('Agree with terms',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    fixedSize: Size(width / 3, 50)),
                                child: const Text('Register'),
                                onPressed: isChecked
                                    ? _registerAccountDialog
                                    : showsDialog),
                          ]),
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
                  "Already Account? ",
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
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => LoginScreen()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showsDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Please Aggre with terms"),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Close",
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

  void _registerAccountDialog() {
    if (!formKey.currentState!.validate()) {
      print("OK");
    } else {
      register();
    }
  }

  void register() async {
    try {
      setState(() {
        loading = true;
      });
      var response =
          await http.post(Uri.parse(baseUrl + '?dest=addUser'), body: {
        'name': name.text,
        'pass1': pass1.text,
        'email': email.text,
      });
      print(response.body);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        loading = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Sucess"),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    "Close",
                    style: TextStyle(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => LoginScreen()));
                  },
                )
              ],
            );
          });
    }
  }

  void _showEULA() {
    loadEula();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "EULA",
          ),
          content: SizedBox(
            height: height / 1.5,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                      child: RichText(
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                        ),
                        text: eula),
                  )),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  loadEula() async {
    eula = await rootBundle.loadString('assets/eula.txt');
  }
}
