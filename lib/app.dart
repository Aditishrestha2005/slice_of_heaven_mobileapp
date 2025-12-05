import 'package:flutter/material.dart';
import 'package:slice_of_heaven/screen/getstartedpage_screen.dart';
import 'package:slice_of_heaven/screen/onboarding_screen.dart';
import 'package:slice_of_heaven/screen/splash_screen.dart';

class App extends StatelessWidget {
const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:SplashScreen(),
    );
  }
}