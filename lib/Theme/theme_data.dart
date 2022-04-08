import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class MyTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    primarySwatch: primaryColor,
    fontFamily: GoogleFonts.titilliumWeb().fontFamily,
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: Colors.white,
        letterSpacing: 1.15,
      ),
      headline2: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
      headline3: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      bodyText1: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: Colors.white,
      ),
      bodyText2: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Colors.white,
      ),
      button: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      elevation: 2,
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: Colors.white,
        letterSpacing: 1.15,
      ),
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
    ),
  );
}
