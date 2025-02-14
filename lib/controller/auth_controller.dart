import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  // Sign Up Method
  Future<void> signUp(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      Get.snackbar("Success", "Account Created Successfully");
      // Get.offAllNamed('/home');  // Navigate to Home Screen
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Sign In Method
  Future<void> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar("Success", "Logged In Successfully");
      // Get.offAllNamed('/home');  // Navigate to Home Screen
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Sign Out Method
  Future<void> signOut() async {
    await auth.signOut();
    Get.offAllNamed('/signin'); // Navigate to SignIn Screen
  }
}
