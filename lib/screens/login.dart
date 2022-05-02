import 'package:flutter/material.dart';
import 'package:project_name/screens/home.dart';
import 'package:project_name/screens/signup.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project_name/util/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailCtrl = TextEditingController(text: "eduardo@mail.com");
  final TextEditingController _passwordCtrl = TextEditingController(text: "123456");
  final box = GetStorage();

  login() async {
    print(_emailCtrl.text);
    print(_passwordCtrl.text);
    var resp = await http.post(
      Uri.parse(Constants().apiURL + "auth/login"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "email": _emailCtrl.text,
        "password": _passwordCtrl.text,
      }),
    );
    print(json.decode(resp.body));
    var tmp = json.decode(resp.body);
    if (tmp["status"] == true) {
      print(tmp["data"]["token"]);
      box.write('token', tmp["data"]["token"]);

       box.write('name', tmp["data"]["user"]["name"]);
      box.write('email', tmp["data"]["user"]["email"]);
      box.write('mobile', tmp["data"]["user"]["mobile"]);
      box.write('imgURL', tmp["data"]["user"]["imgURL"]);
      Get.offAll(const HomeScreen());

      
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Scaffold(
          body: ListView(
            children: [
              Expanded(
                  flex: 2,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      // ignore: avoid_unnecessary_containers
                      Container(
                        child: Image.asset(
                          "assets/images/background.png",
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Container(
                        width: 240,
                        height: 160,
                        child: Image.asset("assets/images/logo.png"),
                      ),
                    ],
                  )),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        TextField(
                          controller: _emailCtrl,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextField(
                          controller: _passwordCtrl,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Container(
                          width: 360,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange[800],
                            ),
                            onPressed: () {
                              login();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text(
                                  "Login",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 360,
                          height: 60,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.orange[800],
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupScreen()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have any account?",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.orange[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
