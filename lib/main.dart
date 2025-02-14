import 'package:chatmessage/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './authentication/signin_screen.dart';
import 'authentication/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/signin',
      getPages: [
        GetPage(name: '/signin', page: () => SignInScreen()),
        GetPage(name: '/signup', page: () => SignUpScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
      ],
    );
  }
}
