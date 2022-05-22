import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_name/screens/home.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

import '../controllers/profile.dart';

class CreateAddScreen extends StatefulWidget {
  const CreateAddScreen({Key? key}) : super(key: key);

  @override
  State<CreateAddScreen> createState() => _CreateAddScreenState();
}

class _CreateAddScreenState extends State<CreateAddScreen> {
  final ProfileController _profileCtrl = Get.put(ProfileController());

  TextEditingController _titleCtrl = TextEditingController();
  TextEditingController _descriptionCtrl = TextEditingController();
  TextEditingController _mobileCtrl = TextEditingController();
  TextEditingController _priceCtrl = TextEditingController();
  var _imageAd = "";
  var userObj;
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  var _userName;

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  uploadImage() async {
    var filePath = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (filePath!.path.length != 0) {
      File file = File(filePath.path);
      var storageRef = await FirebaseStorage.instance
          .ref()
          .child("uploads")
          .child(getRandomString(12))
          .putFile(file);

      var uploadedURL = await storageRef.ref.getDownloadURL();
      print(uploadedURL);
      setState(() {
        _imageAd = uploadedURL;
      });
    }
  }

  createAdd() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection("ads").doc(getRandomString(12)).set({
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "title": _titleCtrl.text,
      "description": _descriptionCtrl.text,
      "mobile": _mobileCtrl.text,
      "price": _priceCtrl.text,
      "images": _imageAd,
      "authorName": _userName,
      "createdAt": FieldValue.serverTimestamp(),
    });
    Get.offAll(const HomeScreen());
  }

   getUserData() {
    FirebaseFirestore.instance
        .collection("accounts")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((res) {
      setState(
        () {
          userObj = {"id": res.id, ...res.data()!};
          _userName = userObj['displayName'];
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Ad"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            top: 16.0,
            right: 16.0,
            left: 16.0,
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                children: [
                  IconButton(
                      onPressed: () {
                        uploadImage();
                      },
                      icon: const Icon(
                        Icons.add_a_photo_outlined,
                        size: 32.0,
                      )),
                  const SizedBox(
                    height: 4.0,
                  ),
                  const Text("Tap to upload"),
                ],
              ),
            ),
            const SizedBox(height: 4),
            const SizedBox(
              height: 12,
            ),
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              controller: _priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Price',
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              controller: _mobileCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Contact Number',
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              controller: _descriptionCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
                contentPadding: EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 12,
                ),
              ),
            ),
            const SizedBox(
              height: 28,
            ),
            SizedBox(
              width: 360,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange[800],
                ),
                onPressed: () {
                  createAdd();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "Create Ad",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
