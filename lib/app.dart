import 'package:flutter/material.dart';
import 'package:slice_of_heaven/screen/splash_screen.dart';
import 'package:slice_of_heaven/theme/appbar_theme.dart';
import 'package:slice_of_heaven/theme/bottomnavigationbar_theme.dart';

import 'package:slice_of_heaven/theme/theme_data.dart'; 

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Apps for College',
      debugShowCheckedModeBanner: false,
      // theme: AppTheme.lightTheme().copyWith(
      //   appBarTheme: getAppBarTheme(),
      //   // inputDecorationTheme: InputDecorationTheme(),
      //   // bottomNavigationBarTheme: getBottomNavigationBarTheme(),
      // ),
      home: const SplashScreen(),
    );
  }
}
