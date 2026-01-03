import 'package:flutter/material.dart';

InputDecorationTheme getInputDecorationTheme() {
  return InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade200,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color.fromARGB(255, 17, 17, 16)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 5, 5, 4),
        width: 2,
      ),
    ),
    labelStyle: const TextStyle(
      fontFamily: 'OpenSans-Regular',
      fontSize: 14,
      color: Colors.black87,
    ),
  );
}
