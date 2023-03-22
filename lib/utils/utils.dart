import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  void showSnackBar(String errorText) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(
          errorText,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'dity'
          ),
        ),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        elevation: 8,
      ),
    );
  }
}
