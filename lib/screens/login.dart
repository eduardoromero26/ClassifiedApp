import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_name/controllers/auth.dart';

import 'package:project_name/screens/home.dart';
import 'package:project_name/screens/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailCtrl =
      TextEditingController(text: "ed@mail.com");
  TextEditingController _passwordCtrl = TextEditingController(text: "123456");
  AuthController _auth = Get.put(AuthController());

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
                      SizedBox(
                        width: 240,
                        height: 160,
                        child: Image.asset("assets/images/logo.png"),
                      ),
                      SizedBox(
                        height: 200,
                      )
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
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 360,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange[800],
                            ),
                            onPressed: () {
                              _auth.loginWithEmailPassword(
                                  _emailCtrl.text, _passwordCtrl.text);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text(
                                  "Login with Mail",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(Icons.mail_outline),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 12,
                        ),
                        SizedBox(
                          width: 360,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              _auth.loginWithGoogle();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text(
                                  "Login with Google",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(
                                  Icons.person_outlined,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 360,
                          height: 60,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.orange[800],
                            ),
                            onPressed: () {
                              Get.to(const registerScreen());
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
