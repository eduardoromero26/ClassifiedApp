import 'package:flutter/material.dart';
import 'dart:math';

import 'package:get/get.dart';
import 'package:project_name/controllers/ads.dart';
import 'package:project_name/screens/home.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../controllers/profile.dart';

class EditAddScreen extends StatefulWidget {
  var objApi;
  EditAddScreen({
    Key? key,
    required this.objApi,
  }) : super(key: key);

  @override
  State<EditAddScreen> createState() => _EditAddScreenState();
}

class _EditAddScreenState extends State<EditAddScreen> {
  TextEditingController _titleCtrl = TextEditingController();
  TextEditingController _descriptionCtrl = TextEditingController();
  TextEditingController _mobileCtrl = TextEditingController();
  TextEditingController _priceCtrl = TextEditingController();
  final AdController _AdCtrl = Get.put(AdController());

  var adsCollection = FirebaseFirestore.instance.collection('ads');
  var _uploadImages = "";
  var adsObj;
  var userObj;
  var _imageAd = "";

  var images = [];
  var _imagesLength;
  //var _imagePath = "";

  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  var _userName;

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future readAdData() async {
    _titleCtrl.text = widget.objApi['title'];
    _descriptionCtrl.text = widget.objApi['description'];
    _priceCtrl.text = widget.objApi['price'].toString();
    _mobileCtrl.text = widget.objApi['mobile'].toString();
    _uploadImages = widget.objApi['images'];
    setState(() {});
  }

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
        _uploadImages = uploadedURL;
      });
    }
  }

  editAdd() async {
    FirebaseFirestore.instance
        .collection("ads")
        .doc(widget.objApi['sku'])
        .update({
      "title": _titleCtrl.text,
      "description": _descriptionCtrl.text,
      "mobile": _mobileCtrl.text,
      "price": _priceCtrl.text,
      "images": _uploadImages,
    });
    Get.offAll(const HomeScreen());
  }

/*
  deleteAdd() async {
    var token = box.read('token');
    var resp = await http.delete(
      Uri.parse(Constants().apiURL + 'ads/' + widget.objApi['_id']),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    Get.offAll(const HomeScreen());
  }
*/
  @override
  void initState() {
    readAdData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Ad"),
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
            SizedBox(
              height: 100,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                scrollDirection: Axis.horizontal,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: Image.network(
                      _uploadImages,
                      height: 80,
                      width: 80,
                    ),
                  );
                },
              ),
            ),
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
                  editAdd();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "Edit Ad",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 360,
              height: 52,
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.orange[800],
                ),
                onPressed: () {
                  //deleteAdd();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "Delete Ad",
                      style: TextStyle(
                        fontSize: 18,
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
