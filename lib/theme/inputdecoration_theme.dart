import 'package:flutter/material.dart';

InputDecorationTheme getinputdecorationtheme(){
  return InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade200,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color.fromARGB(255, 227, 143, 8)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color.fromARGB(255, 228, 143, 5), width: 2),
    ),
    labelStyle: const TextStyle(
      fontFamily: 'OpenSans-Regular',
      fontSize: 14,
      color: Colors.black87,
    ),
  );
}