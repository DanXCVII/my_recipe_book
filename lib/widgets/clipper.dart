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

class RightArrow extends CustomClipper<Path> {
  RightArrow();

  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, 0)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.5, 0, size.height)
      ..quadraticBezierTo(
          size.width / 2, size.height / 2, size.width, size.height / 2)
      ..quadraticBezierTo(size.width / 2, size.height / 2, 0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(RightArrow oldClipper) => true;
}

class LeftArrow extends CustomClipper<Path> {
  LeftArrow();

  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(size.width, 0)
      ..quadraticBezierTo(
          size.width * 0.8, size.height * 0.5, size.width, size.height)
      ..quadraticBezierTo(size.width / 2, size.height / 2, 0, size.height / 2)
      ..quadraticBezierTo(size.width / 2, size.height / 2, size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(LeftArrow oldClipper) => true;
}
