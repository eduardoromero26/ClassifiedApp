import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_name/screens/home.dart';
import 'package:project_name/screens/login.dart';

class registerScreen extends StatefulWidget {
  const registerScreen({Key? key}) : super(key: key);

  @override
  State<registerScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<registerScreen> {
  TextEditingController _nameCtrl = TextEditingController();
  TextEditingController _emailCtrl = TextEditingController();
  TextEditingController _mobileCtrl = TextEditingController();
  TextEditingController _passwordCtrl = TextEditingController();

  register() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: _emailCtrl.text,
      password: _passwordCtrl.text,
    )
        .then((value) {
      print("Login Success");
      insertToFirestore();
      Get.to(HomeScreen());
    }).catchError((e) {
      print(e);
    });
  }

  insertToFirestore() {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection("accounts").doc(uid).set({
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "displayName": _nameCtrl.text,
      "email": _emailCtrl.text,
      "mobile": _mobileCtrl.text,
      "createdAt": FieldValue.serverTimestamp(),
      "imageURL": "https://picsum.photos/200/300",
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Scaffold(
          body: ListView(
            children: [
              Expanded(
                  flex: 1,
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
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        TextField(
                          controller: _nameCtrl,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Full Name',
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextField(
                          controller: _emailCtrl,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email Adress',
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextField(
                          controller: _mobileCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Mobile Number',
                          ),
                        ),
                        const SizedBox(
                          height: 8,
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
                          height: 40,
                        ),
                        Container(
                          width: 360,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange[800],
                            ),
                            onPressed: () {
                              register();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text(
                                  "Register Now",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
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
                                          const LoginScreen()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
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
