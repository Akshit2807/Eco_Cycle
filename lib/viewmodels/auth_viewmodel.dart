import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  Map<String, dynamic>? userInfoMap;
  User? get user => _user;
  bool? forgetStatus;

  Future<void> signIn(BuildContext context, String email, String password,
      String userName) async {
    try {
      userInfoMap = await _authService.signIn(email, password, userName);
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            margin: EdgeInsets.only(
              bottom: kBottomNavigationBarHeight + 16,
              left: 16,
              right: 16,
            ),
            behavior: SnackBarBehavior.floating,
            content: Text("Login successful!"),
            backgroundColor: Colors.green),
      );
      print(userInfoMap!.putIfAbsent("name", () => userName));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString()), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> signUp(BuildContext context, String email, String password,
      String userName) async {
    try {
      _user = await _authService.signUp(email, password, userName);
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            margin: EdgeInsets.only(
              bottom: kBottomNavigationBarHeight + 16,
              left: 16,
              right: 16,
            ),
            behavior: SnackBarBehavior.floating,
            content: Text("Signup successful!"),
            backgroundColor: Colors.green),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString()), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _authService.signOut();
    _user = null;
    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Logged out successfully!"),
          backgroundColor: Colors.blue),
    );
  }

  Future<void> forgetPass(BuildContext context, String email) async {
    try {
      forgetStatus = await _authService.forgetPass(email);
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Password Reset Email has been sent !"),
            backgroundColor: Colors.green),
      );
    } catch (error) {
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString()), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      _user = await _authService.signInWithGoogle();
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Google Sign-In successful!"),
            backgroundColor: Colors.green),
      );
    } catch (error) {
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString()), backgroundColor: Colors.red),
      );
    }
  }
}
