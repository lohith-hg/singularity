import 'dart:ui';

import 'package:flutter/material.dart';

class DashLinePainter extends CustomPainter {
  final Paint _paint = Paint()
    ..color = Colors.white
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    var mercury = Path()
      ..moveTo(0, size.height / 0.8)
      ..arcToPoint(Offset(size.width, size.height / 1.16),
          radius: const Radius.circular(100), clockwise: true, rotation: 50);

    var venus = Path()
      ..moveTo(0, size.height / 0.7)
      ..arcToPoint(Offset(size.width, size.height / 1.34),
          radius: const Radius.circular(100), clockwise: true, rotation: 50);

    var earth = Path()
      ..moveTo(0, size.height / 0.6)
      ..arcToPoint(Offset(size.width, size.height / 1.6),
          radius: const Radius.circular(100), clockwise: true, rotation: 50);

    var mars = Path()
      ..moveTo(0, size.height / 0.5)
      ..arcToPoint(Offset(size.width, size.height / 1.96),
          radius: const Radius.circular(100), clockwise: true, rotation: 50);

    var jupiter = Path()
      ..moveTo(0, size.height / 0.4)
      ..arcToPoint(Offset(size.width, size.height / 2.5),
          radius: const Radius.circular(100), clockwise: true, rotation: 50);

    var saturn = Path()
      ..moveTo(0, size.height / 0.31)
      ..arcToPoint(Offset(size.width, size.height / 3.5),
          radius: const Radius.circular(100), clockwise: true, rotation: 100);

    var uranus = Path()
      ..moveTo(0, size.height / 0.3)
      ..arcToPoint(Offset(size.width, size.height / 5.9),
          radius: const Radius.circular(100), clockwise: true, rotation: 50);

    var neptune = Path()
      ..moveTo(0, size.height / 0.29)
      ..arcToPoint(Offset(size.width, size.height / 16),
          radius: const Radius.circular(100), clockwise: true, rotation: 50);

    Path dashPath = Path();

    double dashWidth = 10.0;
    double dashSpace = 5.0;
    double distance = 0.0;

    List<Path> paths = [
      mercury,
      venus,
      earth,
      mars,
      jupiter,
      saturn,
      uranus,
      neptune
    ];

    for (Path p in paths) {
      for (PathMetric pathMetric in p.computeMetrics()) {
        while (distance < pathMetric.length) {
          dashPath.addPath(
            pathMetric.extractPath(distance, distance + dashWidth),
            Offset.zero,
          );
          distance += dashWidth;
          distance += dashSpace;
        }
      }
    }
    canvas.drawPath(dashPath, _paint);
  }

  @override
  bool shouldRepaint(DashLinePainter oldDelegate) => true;
}
