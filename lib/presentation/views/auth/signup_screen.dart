import 'package:e_waste/core/utils/text_validator.dart';
import 'package:e_waste/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/green_world.png', height: 120),
              const Text(
                'Join Us in Building a\nGreener Tomorrow!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/login'),
                              child: const Text('Login'),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text('Sign Up',
                                  style: TextStyle(color: Colors.green)),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Name',
                          ),
                          validator: (value) => value?.isEmpty == true
                              ? 'Name is required'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            hintText: 'Email',
                          ),
                          validator: TextValidator.validateEmail,
                        ),
                        const SizedBox(height: 16),
                        Consumer<AuthViewModel>(
                          builder: (context, viewModel, _) => TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              hintText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(viewModel.isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: viewModel.togglePasswordVisibility,
                              ),
                            ),
                            obscureText: !viewModel.isPasswordVisible,
                            validator: TextValidator.validatePassword,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Consumer<AuthViewModel>(
                          builder: (context, viewModel, _) => TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              hintText: 'Confirm Password',
                              suffixIcon: IconButton(
                                icon: Icon(viewModel.isConfirmPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed:
                                    viewModel.toggleConfirmPasswordVisibility,
                              ),
                            ),
                            obscureText: !viewModel.isConfirmPasswordVisible,
                            validator: (value) =>
                                TextValidator.validateConfirmPassword(
                                    value, _passwordController.text),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Consumer<AuthViewModel>(
                          builder: (context, viewModel, _) => ElevatedButton(
                            onPressed: viewModel.isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      viewModel.signUpWithEmail(
                                        _emailController.text,
                                        _passwordController.text,
                                      );
                                    }
                                  },
                            child: viewModel.isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Sign Up'),
                          ),
                        ),
                        const Divider(height: 40),
                        Consumer<AuthViewModel>(
                          builder: (context, viewModel, _) =>
                              OutlinedButton.icon(
                            onPressed: viewModel.isLoading
                                ? null
                                : viewModel.signInWithGoogle,
                            icon: Image.asset('assets/google_logo.png',
                                height: 24),
                            label: const Text('Continue with Google'),
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/login'),
                          child: const Text('Already have an account? Login'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
