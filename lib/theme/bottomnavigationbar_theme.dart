import 'package:flutter/material.dart';

BottomNavigationBarThemeData getBottomNavigationBarTheme() {
  return BottomNavigationBarThemeData(
    backgroundColor: const Color.fromARGB(255, 198, 116, 9),
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.white,
    selectedLabelStyle: const TextStyle(
      fontFamily: 'OpenSans-Bold',
      fontSize: 14,
    ),
    unselectedLabelStyle: const TextStyle(
      fontFamily: 'OpenSans-Regular',
      fontSize: 12,
      
    ),
  );
}