import 'package:e_waste/presentation/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'screens/navigation_screen.dart';

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
        if (snapshot.hasError) {
          return const Center(
              child:
                  Text('An error occurred. Please try again.')); // Error state
        } else {
          // Check if the user is logged in
          if (snapshot.hasData) {
            if (snapshot.data!.email == null) {
              return const SplashScreen(); // User is not verified
            } else {
              return const NavigationScreen(); // User is logged in
            }
          } else {
            return const SplashScreen(); // User is not logged in
          }
        }
      },
    );
  }
}
