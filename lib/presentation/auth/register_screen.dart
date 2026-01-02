import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test/application/auth/auth.dart';
import 'package:test/application/auth/auth_bloc.dart';
import 'package:test/application/core/utils/enums.dart';
import 'package:test/presentation/home_screen.dart';

import 'package:test/presentation/widgets/custom_field.dart';
import 'package:test/presentation/widgets/password_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignUpWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo/Brand
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'STORE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 8,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 64),

                  // Email Field
                  CustomFieldWidget(
                    emailController: _emailController,
                    hint: "EMAIL",
                  ),

                  const SizedBox(height: 24),

                  // PasswordField(passwordController: _passwordController),
                  // const SizedBox(height: 24),
                  PasswordField(
                    passwordController: _passwordController,
                    confirmController: _confirmPasswordController,
                  ),

                  const SizedBox(height: 12),

                  const SizedBox(height: 48),

                  // Login Button
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state.authState == ApiState.success) {
                        Fluttertoast.showToast(msg: "Login Successfull");

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      }
                      if (state.authState == ApiState.failure) {
                        Fluttertoast.showToast(msg: state.errorMessage ?? "");
                      }
                    },
                    listenWhen: (previous, current) =>
                        previous.authState != current.authState,

                    builder: (context, authstate) {
                      return SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: authstate.authState == ApiState.loading
                              ? null
                              : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: authstate.authState == ApiState.loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.black),
                    child: const Text(
                      'Back To Login',
                      style: TextStyle(
                        fontSize: 13,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
