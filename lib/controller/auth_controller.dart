import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> signUp(String mobile, String name, String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await firestore.collection("users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "name": name,
        "mobile": mobile,
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
      });

      Get.snackbar("Success", "Account Created Successfully");
      Get.offAllNamed('/home');  // Navigate to Home Screen
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> signIn(String login, String password) async {
    try {
      String email = login.contains('@') ? login : "$login@example.com";
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar("Success", "Logged In Successfully");
      Get.offAllNamed('/home'); 
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
    Get.offAllNamed('/signin');
  }
}
