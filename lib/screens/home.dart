import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_name/custom-widgets/ProductCardWidget.dart';
import 'package:project_name/screens/settings.dart';
import 'package:project_name/screens/create_ad.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var userObj = {};
  bool isLoading = true;
  String _profileImage = "";
  var adsObj;

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _mobileCtrl = TextEditingController();

  final TextEditingController _adTitleCtrl = TextEditingController();
  final TextEditingController _adPriceCtrl = TextEditingController();
  final TextEditingController _adImageAdCtrl = TextEditingController();
  CollectionReference adsCollection =
      FirebaseFirestore.instance.collection('ads');

  getUserData() {
    FirebaseFirestore.instance
        .collection("accounts")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((res) {
      setState(
        () {
          userObj = {"id": res.id, ...res.data()!};
          _profileImage = userObj['imageURL'];
        },
      );
    });
  }

  getAdsData() async {
    QuerySnapshot querySnapshotAds = await adsCollection.get();
    setState(() {
      adsObj = querySnapshotAds.docs.map((doc) => doc.data()).toList();
    });
  }

  Future getAdsLoadingController() async {
    var resp = await getAdsData();
    print(adsObj);
    if (resp != "Error") {
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getUserData();
    getAdsLoadingController();
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
          itemCount: adsObj.length,
          itemBuilder: (BuildContext context, int index) {
            return ProductCardWidget(objApi: adsObj[index]);
          },
        ),
      ),
    );
  }
}
