import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_waste/core/services/storage_service.dart';
import 'package:e_waste/data/secure_storage/secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('User');

  Future<Map<String, dynamic>?> signIn(
      String email, String password, String userName) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? userDetails = result.user;
      log('=============================================================ID Token=============================================================');
      String? idToken = await userDetails!.getIdToken();
      log("ID Token: ${idToken} \n");
      IdTokenResult idTokenResult = await userDetails!.getIdTokenResult();
      log("ID Token (JWT): ${idTokenResult.token}\n");
      log("ID Token (JSON): ${idTokenResult.claims}");
      log('=============================================================ID Token=============================================================');
      TokenService().saveToken(idToken!);

      if (result != null) {
        DocumentSnapshot documentSnapshot =
            await userCollection.doc(userDetails!.uid).get();
        if (documentSnapshot.exists) {
          return documentSnapshot.data() as Map<String, dynamic>?;
        }
      }
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Login failed. Please try again.";
    }
  }

  Future<User?> signUp(String email, String password, String userName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? userDetails = result.user;
      if (result != null) {
        Map<String, dynamic> userInfoMap = {
          "email": userDetails!.email,
          "name": userName,
          "id": userDetails.uid
        };
        await DatabaseMethods()
            .addUser(userDetails.uid, userInfoMap)
            .then((value) {
          print("User Added");
        });
      }
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Signup failed. Please try again.";
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<bool> forgetPass(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      return false;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential result = await _auth.signInWithCredential(credential);
      User? userDetails = result.user;
      if (result != null) {
        Map<String, dynamic> userInfoMap = {
          "email": userDetails!.email,
          "name": userDetails.displayName,
          "id": userDetails.uid
        };
        await DatabaseMethods()
            .addUser(userDetails.uid, userInfoMap)
            .then((value) {
          print("User Added");
        });
      }
      return result.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e.message ?? "Google Sign-In failed. Please try again.";
    }
  }
}
