import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class Utils {
  void showSnackBar(String errorText) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(
          errorText,
          style: TextStyle(
            color: Colors.black,
            fontFamily: GoogleFonts.titilliumWeb().fontFamily,
          ),
        ),
        backgroundColor: secondaryColor,
        behavior: SnackBarBehavior.floating,
        elevation: 8,
      ),
    );
  }
}
