import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AdController extends GetxController {
  var adsObj = {}.obs;
  var firestore = FirebaseFirestore.instance;

  updateAd(obj, sku) {
    firestore.collection("ad").doc(sku).update(obj);
  }
}
