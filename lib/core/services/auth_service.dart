import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_waste/core/services/local_storage_service/secure_storage.dart';
import 'package:e_waste/core/services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('User');
  final SecureStorageService secureStorageService = SecureStorageService();
  final TokenService tokenService = TokenService();

  Future<String?> refreshFirebaseToken() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String? idToken = await user.getIdToken(true); // Force token refresh
        tokenService.saveToken(idToken!);
        return idToken;
      } else {
        return null; // User not signed in
      }
    } catch (e) {
      log("Error refreshing token: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> signIn(
      String email, String password, String userName) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? userDetails = result.user;
      log('=============================================================ID Token=============================================================');
      String? idToken = await userDetails!.getIdToken();
      log("ID Token: ${idToken} \n");
      // IdTokenResult idTokenResult = await userDetails!.getIdTokenResult();
      // log("ID Token (JWT): ${idTokenResult.token}\n");
      // log("ID Token (JSON): ${idTokenResult.claims}");
      log('=============================================================ID Token=============================================================');
      tokenService.saveToken(idToken!);
      secureStorageService.saveData(value: userName, key: 'currentUserName');
      secureStorageService.saveData(value: email, key: 'currentEmail');
      //Printing user details
      log("User Details: ${userDetails.toString()}");
      print(
          'user details >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      print('username : ${userDetails.displayName}');
      print(secureStorageService.getData('currentUserName'));
      print(secureStorageService.getData('currentEmail'));

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

      // Update the display name for the user.
      await result.user?.updateDisplayName(userName);

      // Optional: Reload the user to ensure the update is applied immediately.
      await result.user?.reload();

      User? userDetails = result.user;
      if (result != null) {
        Map<String, dynamic> userInfoMap = {
          "email": userDetails!.email,
          "displayName": userName,
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
