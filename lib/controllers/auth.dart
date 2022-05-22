import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_name/controllers/profile.dart';
import 'package:project_name/screens/home.dart';
import 'package:project_name/screens/login.dart';

class AuthController extends GetxController {
  ProfileController _profileCtrl = Get.put(ProfileController());
  var _auth = FirebaseAuth.instance;

  void loginWithEmailPassword(email, password) async {
    var authRes = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (authRes != null) {
      Get.to(HomeScreen());
    }
  }

  void registerWithEmailPassword(user) async {
    var authRes = await _auth.createUserWithEmailAndPassword(
      email: user['email'],
      password: user['password'],
    );

    _profileCtrl.createProfileOnFireStore({
      "uid": authRes.user!.uid,
      "displayName": user['displayName'],
      "email": user['email'],
      "mobile": user['mobile'],
      "imageURL": "https://picsum.photos/200/300",
      "createdAt": FieldValue.serverTimestamp()
    });
  }

  void loginWithGoogle() async {
    var account = await GoogleSignIn(scopes: ["email"]).signIn();
    var auth = await account!.authentication;
    var credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    var userRef = await _auth.signInWithCredential(credential);
    print(userRef.user);
    if (userRef.additionalUserInfo!.isNewUser) {
      _profileCtrl.createProfileOnFireStore({
        "uid": userRef.user!.uid,
        "displayName": account.displayName,
        "email": account.email,
        "imageURL": account.photoUrl,
        "createdAt": FieldValue.serverTimestamp()
      });
    }
    if (userRef.user != null) {
      Get.offAll(HomeScreen());
    }
  }

  void logout() {
    _auth.signOut().then((value) {
      Get.offAll(LoginScreen());
    });
  }
}
