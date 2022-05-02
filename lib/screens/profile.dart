import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project_name/util/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_name/screens/home.dart';
import 'package:project_name/screens/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _mobileCtrl = TextEditingController();
  var _profileImage = "";
  var _imagePath = "";
  final box = GetStorage();

  readUserData() async {
    var token = box.read('token');
    var resp = await http.post(
      Uri.parse(Constants().apiURL + 'user/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    var tmp = json.decode(resp.body);

    print(tmp);
    if (tmp['status'] == true) {
      _nameCtrl.text = tmp['data']['name'];
      _emailCtrl.text = tmp['data']['email'];
      _mobileCtrl.text = tmp['data']['mobile'];
      _profileImage = tmp['data']['imgURL'];
      setState(() {});
    }
  }

  pickImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
      print(_imagePath);
      
    } else {
      print("No image picked");
    }
  }

  updateProfile() async {
    // upload image
    var request = http.MultipartRequest(
        "POST", Uri.parse(Constants().apiURL + 'upload/profile'));
    request.files.add(await http.MultipartFile.fromPath('avatar', _imagePath));
    var res = await request.send();
    var respData = await res.stream.toBytes();
    var respStr = String.fromCharCodes(respData);
    var jsonObj = json.decode(respStr);
    print(jsonObj["data"]["path"]);

    setState(() {
      _profileImage = jsonObj["data"]["path"];
    });

    // update petition
    var token = box.read('token');
    var resp = await http.patch(
      Uri.parse(Constants().apiURL + 'user/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({
        "name": _nameCtrl.text,
        "email": _emailCtrl.text,
        "mobile": _mobileCtrl.text,
        "imgURL": _profileImage,
      }),
    );
    print(json.decode(resp.body));
  }

  @override
  void initState() {
    readUserData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
                    pickImage();
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      backgroundImage: NetworkImage(_profileImage),
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
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: _emailCtrl,
                decoration: const InputDecoration(
                  border: const OutlineInputBorder(),
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
              SizedBox(
                width: 360,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange[800],
                  ),
                  onPressed: () {
                    updateProfile();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
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
              SizedBox(
                width: 360,
                height: 60,
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.orange[900],
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
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
