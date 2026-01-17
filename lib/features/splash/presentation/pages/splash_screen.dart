import 'dart:async';
import 'package:flutter/material.dart';
import 'package:slice_of_heaven/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:slice_of_heaven/screen/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool isLoggedIn;

  const SplashScreen({
    super.key,
    required this.isLoggedIn,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    if (widget.isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0B09),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash_screen.png',
              width: 250,
              height: 250,
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              color: Color.fromARGB(255, 223, 108, 7),
            ),
            const SizedBox(height: 20),
            const Text(
              "Loading Slice of Heaven...",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
