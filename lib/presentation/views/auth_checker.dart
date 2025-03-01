import 'package:e_waste/presentation/views/navigation_screen.dart';
import 'package:e_waste/presentation/views/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Loading state
        }
        if (snapshot.hasData) {
          return NavigationScreen(); // User is logged in
        } else {
          return const SplashScreen(); // User is not logged in
        }
      },
    );
  }
}
