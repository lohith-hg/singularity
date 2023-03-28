import 'package:flutter/material.dart';

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double h = size.height;
    double w = size.width;
    Path path = Path()
      ..lineTo(0, h - 80)
      ..quadraticBezierTo(w * 0.5, h + 98, w, h - 122) // Add line p1p2
      ..lineTo(w, 0) // Add line p2p3
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MyCustomClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double h = size.height;
    double w = size.width;

    Path path = Path()
      ..moveTo(0, h)
      ..lineTo(0, h)
      ..quadraticBezierTo(w * 0.4, h - 140, w, h - 60)
      ..lineTo(w, h)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
