import 'package:e_waste/core/controller/login/login_ctrl.dart';
import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/core/utils/text_validator.dart';
import 'package:e_waste/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'auth_actions.dart';
import 'google_signin.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  LoginController loginController = Get.put(LoginController());
  final AuthLoadingController loadingController =
      Get.put(AuthLoadingController());
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xffF1F1F1),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return GetBuilder(
              init: loginController,
              builder: (ctrl) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: size.height * 0.05),

                          /// Head Image
                          Image.asset('assets/auth_top_screen.png',
                              height: size.height * 0.2, fit: BoxFit.contain),

                          const SizedBox(height: 10),

                          ///Head Text
                          const Text(
                            'Join Us in Building a Greener Tomorrow!',
                            style: TextStyle(
                                fontSize: 24,
                                // fontWeight: FontWeight.bold,
                                color: Colors.green),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 20),

                          /// Sliding tab
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _authTab('Sign Up', !ctrl.isLogin,
                                  false), // Sign Up tab
                              _authTab(
                                  'Login', ctrl.isLogin, true), // Login tab
                            ],
                          ),

                          const SizedBox(height: 20),

                          Padding(
                            key: ValueKey<bool>(ctrl.isLogin),
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.08),
                            child: Column(
                              children: [
                                /// Text field when signUp
                                if (!ctrl.isLogin)
                                  _buildTextField(
                                      label: 'Name',
                                      icon: Icons.person,
                                      isObscure: false,
                                      controller: ctrl.nameController,
                                      validator: (name) =>
                                          TxtValidator.validateNull(name)),

                                /// Default text fields

                                /// Email field
                                _buildTextField(
                                  label: 'Email',
                                  icon: Icons.email,
                                  isObscure: false,
                                  controller: ctrl.emailController,
                                  validator: (email) =>
                                      TxtValidator.validateEmail(email),
                                ),

                                /// Password field
                                _buildTextField(
                                  label: 'Password',
                                  icon: Icons.lock,
                                  isObscure: true,
                                  controller: ctrl.passwordController,
                                  validator: (password) =>
                                      TxtValidator.validatePassword(password),
                                ),

                                /// Forget Password
                                if (ctrl.isLogin)
                                  GestureDetector(
                                    onTap: () {
                                      forgetButtonAction(
                                        authViewModel: authViewModel,
                                        context: context,
                                      );
                                    },
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Forget Password?",
                                          style: TextStyle(
                                              color: AppColors.placeHolder,
                                              fontWeight: FontWeight.w500),
                                        )),
                                  ),

                                /// Confirm Password field
                                if (!ctrl.isLogin)
                                  _buildTextField(
                                    label: 'Confirm Password',
                                    icon: Icons.lock,
                                    isObscure: true,
                                    controller: ctrl.confirmPasswordController,
                                    validator: (confirmPassword) =>
                                        TxtValidator.validatePassword(
                                            confirmPassword),
                                  ),
                                const SizedBox(height: 20),

                                /// Login/SignUp Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      ctrl.isLogin
                                          ? loginButtonAction(
                                              authViewModel: authViewModel,
                                              context: context,
                                            )
                                          : signUpButtonAction(
                                              authViewModel: authViewModel,
                                              context: context,
                                            );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: EdgeInsets.symmetric(
                                          vertical: size.height * 0.015),
                                    ),
                                    child: Obx(
                                      () => loadingController.loadingValue.value
                                          ? const CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : Text(
                                              ctrl.isLogin
                                                  ? 'Login'
                                                  : 'Sign Up',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text('OR',
                                    style: TextStyle(color: Colors.grey)),
                                const SizedBox(height: 10),

                                ///Google sign in
                                googleSignIn(authViewModel, context, size),

                                const SizedBox(height: 10),

                                TextButton(
                                  onPressed: ctrl.toggleAuthMode,
                                  // Switch between login and signup
                                  child: RichText(
                                    text: TextSpan(
                                      text: ctrl.isLogin
                                          ? "Don't have an account? "
                                          : "Already have an account? ",
                                      style:
                                          const TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: ctrl.isLogin
                                              ? "Sign Up"
                                              : "Login",
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  // Builds the tab selector for Login/Signup with styling
  Widget _authTab(String text, bool active, bool isLoginTile) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.41,
      child: GestureDetector(
        onTap: ctrl.toggleAuthMode,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? Colors.green : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: isLoginTile
                  ? const Radius.circular(0)
                  : const Radius.circular(10),
              topRight: isLoginTile
                  ? const Radius.circular(10)
                  : const Radius.circular(0),
              bottomRight: isLoginTile
                  ? const Radius.circular(10)
                  : const Radius.circular(0),
              bottomLeft: isLoginTile
                  ? const Radius.circular(0)
                  : const Radius.circular(10),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
                color: active ? Colors.white : Colors.green,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // Builds a text field dynamically with a border
  Widget _buildTextField(
      {required String label,
      required IconData icon,
      required bool isObscure,
      required TextEditingController controller,
      String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }
}
