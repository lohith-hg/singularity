import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';

class Utils {
  void showSnackBar(String errorText) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(
          errorText,
          style: const TextStyle(color: Colors.black, fontFamily: 'dity'),
        ),
        backgroundColor: secondaryColor,
        behavior: SnackBarBehavior.floating,
        elevation: 8,
      ),
    );
  }
}
