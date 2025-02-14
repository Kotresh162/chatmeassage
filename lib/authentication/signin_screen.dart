import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class SignInScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Sign In")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: loginController,
                decoration: const InputDecoration(labelText: "Enter Mobile Number or Email"),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Enter the Password"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  authController.signIn(loginController.text, passwordController.text);
                },
                child: const Text("Sign In"),
              ),
              TextButton(
                onPressed: () => Get.toNamed('/signup'),
                child: const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
