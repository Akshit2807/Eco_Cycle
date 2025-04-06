// Login Button Action
import 'package:e_waste/core/controller/login/login_ctrl.dart';
import 'package:e_waste/core/router/app_router.dart';
import 'package:e_waste/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final LoginController ctrl = Get.put(LoginController());


void loginButtonAction({
  required AuthViewModel authViewModel,
  required BuildContext context,
}) async {
  try {
    debugPrint("Attempting to login with email: ${ctrl.emailController.text}");
    await authViewModel.signIn(
      context,
      ctrl.emailController.text,
      ctrl.passwordController.text,
      ctrl.nameController.text,
    );

    // Check if the user is successfully logged in
    if (authViewModel.userInfoMap != null) {
      // Clear all text fields after login
      ctrl.clearControllers();
      debugPrint("Login successful! Navigating to home screen.");
      Get.offAllNamed(RouteNavigation.navScreenRoute);
    } else {
      debugPrint("Login failed: userInfoMap is null");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login failed. Please check your credentials."),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e, stacktrace) {
    debugPrint("Error during login: $e\nStacktrace: $stacktrace");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("An error occurred: $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
}

void signUpButtonAction({
  required AuthViewModel authViewModel,
  required BuildContext context,
}) async {
  try {
    if (ctrl.passwordController.text != ctrl.confirmPasswordController.text) {
      debugPrint("Sign-up failed: passwords do not match");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Confirm password does not match"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    debugPrint("Attempting to sign up with email: ${ctrl.emailController.text}");
    await authViewModel.signUp(
      context,
      ctrl.emailController.text,
      ctrl.passwordController.text,
      ctrl.nameController.text,
    );

    // Check if the user is successfully signed up
    if (authViewModel.user != null) {
      // Clear all text fields after sign-up
      ctrl.clearControllers();
      debugPrint("Sign-up successful! Navigating to home screen.");
      Get.offAllNamed(RouteNavigation.navScreenRoute);
    } else {
      debugPrint("Sign-up failed: user is null");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Sign-up failed. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e, stacktrace) {
    debugPrint("Error during sign-up: $e\nStacktrace: $stacktrace");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("An error occurred: $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
}


// Forget Pass Button Action
void forgetButtonAction({
  required AuthViewModel authViewModel,
  required BuildContext context,
}) async {
  if (ctrl.emailController.text.isEmpty || ctrl.emailController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Enter Valid Email"), backgroundColor: Colors.red),
    );
  } else if (!RegExp(
          r'^(?!.*\s)[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
      .hasMatch(ctrl.emailController.text)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Enter Valid Email"), backgroundColor: Colors.red),
    );
  } else {
    await authViewModel.forgetPass(
      context,
      ctrl.emailController.text,
    );
  }
}
