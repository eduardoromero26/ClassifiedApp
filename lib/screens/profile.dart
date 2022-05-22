import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project_name/screens/home.dart';
import 'package:project_name/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:project_name/controllers/auth.dart';
import 'package:project_name/controllers/profile.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  var userObj = {};
  var _imageURL = "";
  final ProfileController _profileCtrl = Get.put(ProfileController());
  final AuthController _authCtrl = AuthController();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _mobileCtrl = TextEditingController();

  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  getUserData() {
    FirebaseFirestore.instance
        .collection("accounts")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((res) {
      setState(
        () {
          userObj = {"id": res.id, ...res.data()!};
          _nameCtrl.text = userObj['displayName'];
          _emailCtrl.text = userObj['email'];
          _mobileCtrl.text = userObj['mobile'];
          _imageURL = userObj['imageURL'];
        },
      );
    });
  }

  uploadImage() async {
    var filePath = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (filePath!.path.length != 0) {
      File file = File(filePath.path);
      var storageRef = await FirebaseStorage.instance
          .ref()
          .child("uploads")
          .child(userObj['uid'])
          .putFile(file);

      var uploadedURL = await storageRef.ref.getDownloadURL();
      print(uploadedURL);
      setState(() {
        _imageURL = uploadedURL;
      });
      _profileCtrl.updateProfile({"imageURL": _imageURL});
    }
  }


  updateProfile() {
    FirebaseFirestore.instance
        .collection("accounts")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "displayName": _nameCtrl.text,
      "mobile": _mobileCtrl.text,
      "email": _emailCtrl.text
    });
    Get.offAll(HomeScreen());
  }

  void logout() {
    FirebaseAuth.instance.signOut().then((value) {
      Get.offAll(const LoginScreen());
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    uploadImage();
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        _imageURL,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: _emailCtrl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: _mobileCtrl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mobile',
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
                    updateProfile();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "Update Profile",
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
                    primary: Colors.orange[900],
                  ),
                  onPressed: () {
                    logout();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
