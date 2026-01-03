import 'package:flutter/material.dart';

BottomNavigationBarThemeData getBottomNavigationBarTheme() {
  return BottomNavigationBarThemeData(
    backgroundColor: const Color.fromARGB(255, 234, 203, 163),
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