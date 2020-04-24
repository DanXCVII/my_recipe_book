import 'dart:ui';

import 'package:flutter/material.dart';

class NutritionDraggableClipper extends CustomClipper<Path> {
  NutritionDraggableClipper();

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 80)
      ..arcToPoint(
        Offset(30, 50),
        clockwise: true,
        radius: Radius.circular(30),
      )
      ..lineTo(size.width - 130, 50)
      ..quadraticBezierTo(size.width - 120, 50, size.width - 110, 25)
      ..quadraticBezierTo(size.width - 100, 0, size.width - 80, 0)
      ..quadraticBezierTo(size.width - 60, 0, size.width - 50, 25)
      ..quadraticBezierTo(size.width - 40, 50, size.width - 30, 50)
      ..arcToPoint(
        Offset(size.width, 80),
        clockwise: true,
        radius: Radius.circular(30),
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(NutritionDraggableClipper oldClipper) => true;
}
