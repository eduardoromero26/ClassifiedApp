import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_name/custom-widgets/MyAdsWidget.dart';

import 'package:http/http.dart' as http;

import '../util/constants.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  List objApi = [];
  final box = GetStorage();

  Future fetchAds() async {
    try {
      var token = box.read('token');
      var resp =
          await http.post(Uri.parse(Constants().apiURL + 'ads/user'), headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });
      var data = json.decode(resp.body);

      // Validations
      return data['data'];
    } catch (e) {
      return "Error";
    }
  }

  Future getAdsFromApi() async {
    var resp = await fetchAds();
    setState(() {
      objApi = resp;
    });
  }

  @override
  void initState() {
    getAdsFromApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Ads"),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: objApi.length,
        itemBuilder: (BuildContext context, int index) {
          return MyAdsWidget(objApi: objApi[index]);
        },
      ),
    );
  }
}
