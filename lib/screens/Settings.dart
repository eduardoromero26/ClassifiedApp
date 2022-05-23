import 'package:flutter/material.dart';
import 'package:project_name/screens/my_ads.dart';
import 'package:project_name/screens/profile.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var userObj = {};
  var _imageURL = "";
  var _userName = "";
  var _userMobile = "";
  final TextEditingController _mobileCtrl = TextEditingController();

  getUserData() async {
    await FirebaseFirestore.instance
        .collection("accounts")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((res) {
      setState(
        () {
          userObj = {"id": res.id, ...res.data()!};
          _userName = userObj['displayName'].toString();
          _userMobile = userObj['mobile'].toString();
          _imageURL = userObj['imageURL'].toString();
        },
      );
    });
  }

  openURL(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      launchUrl(Uri.parse(url));
    } else {}
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seetings"),
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          backgroundImage: NetworkImage(
                            _imageURL,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userName,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              _userMobile,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black38,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    TextButton(
                        onPressed: () {
                          Get.to(const MyProfileScreen());
                        },
                        child: Text(
                          "Edit",
                          style: TextStyle(
                            color: Colors.orange[900],
                          ),
                        )),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  const Icon(
                    Icons.add_a_photo_outlined,
                    color: Colors.black45,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(MyAdsScreen());
                      },
                      child: const Text(
                        "My Ads",
                        style: const TextStyle(color: Colors.black),
                      ))
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  const Icon(
                    Icons.person,
                    color: Colors.black45,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        openURL("https:flutter.dev");
                      },
                      child: const Text(
                        "About Us",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  const Icon(
                    Icons.contacts,
                    color: Colors.black45,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        openURL("tel:" + _mobileCtrl.text);
                      },
                      child: const Text(
                        "Contact Us",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
