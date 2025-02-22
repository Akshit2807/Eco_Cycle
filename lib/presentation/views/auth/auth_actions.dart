// Login Button Action
import 'package:e_waste/core/controller/login/login_ctrl.dart';
import 'package:e_waste/core/router/app_router.dart';
import 'package:e_waste/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

LoginController ctrl = Get.put(LoginController());

void loginButtonAction({
  required AuthViewModel authViewModel,
  required BuildContext context,
}) async {
  await authViewModel.signIn(context, ctrl.emailController.text,
      ctrl.passwordController.text, ctrl.nameController.text);
  if (authViewModel.userInfoMap != null) {
    Get.offAllNamed(RouteNavigation.navScreenRoute);
  }
}

// SignUp Button Action
void signUpButtonAction({
  required AuthViewModel authViewModel,
  required BuildContext context,
}) async {
  if (ctrl.passwordController.text != ctrl.confirmPasswordController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Confirm password does not match"),
          backgroundColor: Colors.red),
    );
  } else {
    await authViewModel.signUp(context, ctrl.emailController.text,
        ctrl.passwordController.text, ctrl.nameController.text);
    if (authViewModel.user != null) {
      Get.offAllNamed(RouteNavigation.navScreenRoute);
    }
  }
}

// Forget Pass Button Action
void forgetButtonAction({
  required AuthViewModel authViewModel,
  required BuildContext context,
}) async {
  if (ctrl.emailController.text == null || ctrl.emailController.text.isEmpty) {
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
