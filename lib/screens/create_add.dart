import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_name/screens/home.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;

import '../util/constants.dart';

class CreateAddScreen extends StatefulWidget {
  const CreateAddScreen({Key? key}) : super(key: key);

  @override
  State<CreateAddScreen> createState() => _CreateAddScreenState();
}

class _CreateAddScreenState extends State<CreateAddScreen> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();
  final TextEditingController _mobileCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();

  var _uploadImages = [];
  final box = GetStorage();
  var areImages = false;

  pickMultipleImage() async {
    var images = await ImagePicker().pickMultiImage();
    if (images!.isNotEmpty) {
      // upload image
      var request = http.MultipartRequest(
          "POST", Uri.parse(Constants().apiURL + '/upload/photos'));
      images.forEach((image) async {
        request.files
            .add(await http.MultipartFile.fromPath('photos', image.path));
      });

      var res = await request.send();
      var respData = await res.stream.toBytes();
      var respStr = String.fromCharCodes(respData);
      var jsonObj = json.decode(respStr);
      setState(() {
        _uploadImages.addAll(jsonObj["data"]["path"]);
      });
    } else {}
  }

  createAdd() async {
    var token = box.read('token');
    var resp = await http.post(
      Uri.parse(Constants().apiURL + '/ads'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({
        "title": _titleCtrl.text,
        "description": _descriptionCtrl.text,
        "price": _priceCtrl.text,
        "mobile": _mobileCtrl.text,
        "images": _uploadImages,
      }),
    );
    Get.offAll(const HomeScreen());
  }

  @override
  void initState() {
    super.initState();
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
                        pickMultipleImage();
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
                itemCount: _uploadImages.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: Image.network(
                      _uploadImages[index],
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
