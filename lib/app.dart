import 'package:flutter/material.dart';
import 'package:slice_of_heaven/screen/getstartedpage_screen.dart';

class App extends StatelessWidget {
const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:GetStartedPageScreen(),
    );
  }
}