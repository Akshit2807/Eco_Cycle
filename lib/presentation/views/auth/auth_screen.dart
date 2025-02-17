import 'package:e_waste/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isLogin = false;

  // Toggles between Login and Signup screens
  void toggleAuthMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
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
                          _authTab('Sign Up', !isLogin), // Sign Up tab
                          _authTab('Login', isLogin), // Login tab
                        ],
                      ),

                      const SizedBox(height: 20),

                      Padding(
                        key: ValueKey<bool>(isLogin),
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.08),
                        child: Column(
                          children: [
                            /// Text field when signUp
                            if (!isLogin)
                              _buildTextField(
                                  label: 'Name',
                                  icon: Icons.person,
                                  isObscure: false,
                                  controller: nameController),

                            /// Default text feilds
                            _buildTextField(
                                label: 'Email',
                                icon: Icons.email,
                                isObscure: false,
                                controller: emailController),
                            _buildTextField(
                                label: 'Password',
                                icon: Icons.lock,
                                isObscure: true,
                                controller: passwordController),
                            const SizedBox(height: 20),

                            /// Login/SignUp Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  isLogin
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
                                child: Text(
                                  isLogin ? 'Login' : 'Sign Up',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text('OR',
                                style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 10),

                            ///Google sign in
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  await authViewModel.signInWithGoogle(context);
                                  if (authViewModel.user != null) {
                                    Navigator.pushReplacementNamed(
                                        context, '/home');
                                  }
                                },
                                icon: Image.asset('assets/google_logo.png',
                                    height: 24),
                                label: const Text(' Continue with Google',
                                    style: TextStyle(color: Colors.black)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFF1F1F1),
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.015),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed:
                                  toggleAuthMode, // Switch between login and signup
                              child: RichText(
                                text: TextSpan(
                                  text: isLogin
                                      ? "Don't have an account? "
                                      : "Already have an account? ",
                                  style: const TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: isLogin ? "Sign Up" : "Login",
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
          },
        ),
      ),
    );
  }

  // Login Button Action

  void loginButtonAction({
    required AuthViewModel authViewModel,
    required BuildContext context,
  }) async {
    await authViewModel.signIn(
        context, emailController.text, passwordController.text);
    if (authViewModel.user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }
  // SignUp Button Action

  void signUpButtonAction({
    required AuthViewModel authViewModel,
    required BuildContext context,
  }) async {
    await authViewModel.signUp(
        context, emailController.text, passwordController.text);
    if (authViewModel.user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  // Builds the tab selector for Login/Signup with styling
  Widget _authTab(String text, bool active) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.41,
      child: GestureDetector(
        onTap: toggleAuthMode,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? Colors.green : Colors.white,
            borderRadius: BorderRadius.circular(10),
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
      required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
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
