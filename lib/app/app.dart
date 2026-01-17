import 'package:flutter/material.dart';
import 'package:slice_of_heaven/features/splash/presentation/pages/splash_screen.dart';
import 'package:slice_of_heaven/app/theme/appbar_theme.dart';
import 'package:slice_of_heaven/app/theme/bottomnavigationbar_theme.dart';
import 'package:slice_of_heaven/app/theme/theme_data.dart'; 

class App extends StatelessWidget {
  final bool isLoggedIn;

  const App({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slice of Heaven',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme().copyWith(
        appBarTheme: getAppBarTheme(),
        inputDecorationTheme: const InputDecorationTheme(),
        bottomNavigationBarTheme: getBottomNavigationBarTheme(),
      ),
      home: SplashScreen(isLoggedIn: isLoggedIn),
    );
  }
}
