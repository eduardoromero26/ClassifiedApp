import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_name/custom-widgets/ProductCardWidget.dart';
import 'package:project_name/screens/Settings.dart';
import 'package:project_name/screens/createAdd.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:project_name/util/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List objApi = [];
  bool isLoading = true;
  final box = GetStorage();
  String _profileImage = "";

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
      _profileImage = tmp['data']['imgURL'];
      setState(() {});
    }
  }

  //ADS API
  Future fetchAds() async {
    try {
      var resp =
          await http.get(Uri.parse(Constants().apiURL + '/ads'), headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      });
      var data = jsonDecode(resp.body);
      // Validations
      return data['data'];
    } catch (e) {
      return "Error";
    }
  }

  Future getAdsFromApi() async {
    var resp = await fetchAds();
    if (resp != "Error") {
      setState(() {
        isLoading = false;
        objApi = resp;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getAdsFromApi();
    readUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[900],
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateAddScreen()));
          // Respond to button press
        },
        child: const Icon(Icons.add_a_photo_outlined),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text("Ads Listing"),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()));
              },
              child: CircleAvatar(
                backgroundColor: Colors.black,
                backgroundImage: NetworkImage(_profileImage),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
          ]),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 2.8,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: objApi.length,
          itemBuilder: (BuildContext context, int index) {
            return ProductCardWidget(objApi: objApi[index]);
          },
        ),
      ),
    );
  }
}
