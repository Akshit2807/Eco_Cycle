import 'package:flutter/material.dart';
import '../core/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  User? get user => _user;

  Future<void> signIn(
      BuildContext context, String email, String password) async {
    try {
      _user = await _authService.signIn(email, password);
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
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString()), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> signUp(
      BuildContext context, String email, String password) async {
    try {
      _user = await _authService.signUp(email, password);
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
      SnackBar(
          content: Text("Logged out successfully!"),
          backgroundColor: Colors.blue),
    );
  }
}
