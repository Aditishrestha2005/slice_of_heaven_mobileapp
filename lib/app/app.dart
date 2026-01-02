import 'package:flutter/material.dart';
import 'package:slice_of_heaven/features/splash/presentation/pages/splash_screen.dart';
import 'package:slice_of_heaven/app/theme/appbar_theme.dart';
import 'package:slice_of_heaven/app/theme/bottomnavigationbar_theme.dart';

import 'package:slice_of_heaven/app/theme/theme_data.dart'; 

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Apps for College',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme().copyWith(
        appBarTheme: getAppBarTheme(), 
          inputDecorationTheme: InputDecorationTheme(),
        bottomNavigationBarTheme: getBottomNavigationBarTheme(),
        
      ),
      home: const SplashScreen(),
    );
  }
}
