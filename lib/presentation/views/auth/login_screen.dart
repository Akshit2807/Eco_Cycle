import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/home');
      },
      child: Scaffold(
        body: Center(
          child: Text("Tap to go Home Screen"),
        ),
      ),
    );
  }
}
