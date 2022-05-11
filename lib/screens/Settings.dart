import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_name/screens/MyAds.dart';
import 'package:project_name/screens/profile.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:project_name/util/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _name = "";
  String _mobile = "";
  var _profileImage = "";
  final box = GetStorage();

// USER API
  readUserData() async {
    var token = box.read('token');
    var resp = await http.post(
      Uri.parse(Constants().apiURL + '/user/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    var tmp = json.decode(resp.body);

    if (tmp['status'] == true) {
      _name = tmp['data']['name'];
      _mobile = tmp['data']['mobile'];
      _profileImage = tmp['data']['imgURL'];
      setState(() {});
    }
  }

  openURL(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      launchUrl(Uri.parse(url));
    } else {}
  }

  @override
  void initState() {
    readUserData();
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
              Container(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          backgroundImage: NetworkImage(_profileImage),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _name,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              _mobile,
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProfileScreen()));
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyAdsScreen()));
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
                        openURL("tel:" + _mobile);
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
