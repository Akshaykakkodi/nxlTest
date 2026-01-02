import 'package:flutter/material.dart';
import 'package:test/domain/core/di/injection.dart';
import 'package:test/presentation/auth/login_screen.dart';
import 'package:test/presentation/home_screen.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SharedPreferences _prefs = sl<SharedPreferences>();
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      _navigateToHome();
    });
  }

  void _navigateToHome() {
    bool? isLoggedIn = _prefs.getBool("is_logged_in");
    if (isLoggedIn == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6E8),
      body: Center(
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(Icons.shopping_bag, size: 80, color: Colors.black),
        ),
      ),
    );
  }
}
