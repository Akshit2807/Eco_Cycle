import 'package:e_waste/core/router/app_router.dart';
import 'package:e_waste/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

SizedBox googleSignIn(
    AuthViewModel authViewModel, BuildContext context, Size size) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: () async {
        await authViewModel.signInWithGoogle(context);
        if (authViewModel.user != null) {
          Get.offAllNamed(RouteNavigation.navScreenRoute);
        }
      },
      icon: Image.asset('assets/google_logo.png', height: 24),
      label: const Text(' Continue with Google',
          style: TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF1F1F1),
        padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
      ),
    ),
  );
}
