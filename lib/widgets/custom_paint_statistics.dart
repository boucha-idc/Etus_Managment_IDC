import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class StatisticsCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Define the custom path
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.36, 0); // Dynamically scaled to screen width
    path_0.lineTo(size.width * 0.05, 0);
    path_0.cubicTo(size.width * 0.02, 0, 0, size.height * 0.065, 0, size.height * 0.065);
    path_0.lineTo(0, size.height * 0.935);
    path_0.cubicTo(0, size.height, size.width * 0.02, size.height * 1.0, size.width * 0.05, size.height * 1.0);
    path_0.lineTo(size.width * 0.95, size.height * 1.0);
    path_0.cubicTo(size.width, size.height * 1.0, size.width, size.height, size.width, size.height * 0.935);
    path_0.lineTo(size.width, size.height * 0.065);
    path_0.cubicTo(size.width, size.height * 0.02, size.width * 0.97, 0, size.width * 0.95, 0);
    path_0.lineTo(size.width * 0.65, 0);
    path_0.cubicTo(size.width * 0.645, 0, size.width * 0.635, size.height * 0.002, size.width * 0.625, size.height * 0.01);
    path_0.lineTo(size.width * 0.6, size.height * 0.024);
    path_0.cubicTo(size.width * 0.595, size.height * 0.03, size.width * 0.58, size.height * 0.03, size.width * 0.57, size.height * 0.03);
    path_0.lineTo(size.width * 0.44, size.height * 0.03);
    path_0.cubicTo(size.width * 0.43, size.height * 0.03, size.width * 0.42, size.height * 0.027, size.width * 0.41, size.height * 0.023);
    path_0.lineTo(size.width * 0.37, size.height * 0.006);
    path_0.cubicTo(size.width * 0.36, size.height * 0.003, size.width * 0.355, 0, size.width * 0.36, 0);
    path_0.close();

    // Paint with a linear gradient
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5, 0), // Start at the center top
      Offset(size.width * 0.5, size.height), // End at the center bottom
      [Color(0xff608BC1), Color(0xffD9D9D9).withOpacity(0.65)],
      [0.04, 1],
    );
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
