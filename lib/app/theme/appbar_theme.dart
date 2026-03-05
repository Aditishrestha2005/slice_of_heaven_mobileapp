import 'package:flutter/material.dart';


AppBarTheme getAppBarTheme(){
  return AppBarTheme(
     backgroundColor: const Color.fromARGB(255, 249, 216, 167),
    elevation: 2,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      color: const Color.fromARGB(255, 113, 6, 6),
      fontWeight: FontWeight.bold,
      fontFamily: 'OpenSansItalic',
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  );
}