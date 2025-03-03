import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  final Axis direction;
  final double dashLength;
  final double dashGap;
  final double thickness;
  final Color color;

  const DashedLine({
    Key? key,
    this.direction = Axis.horizontal,
    this.dashLength = 5.0,
    this.dashGap = 5.0,
    this.thickness = 2.0,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromHeight(thickness),
      painter: DashedLinePainter(
        direction: direction,
        dashLength: dashLength,
        dashGap: dashGap,
        thickness: thickness,
        color: color,
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Axis direction;
  final double dashLength;
  final double dashGap;
  final double thickness;
  final Color color;

  DashedLinePainter({
    required this.direction,
    required this.dashLength,
    required this.dashGap,
    required this.thickness,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    double maxLength =
    direction == Axis.horizontal ? size.width : size.height;
    double currentPosition = 0;

    while (currentPosition < maxLength) {
      if (direction == Axis.horizontal) {
        canvas.drawLine(
          Offset(currentPosition, 0),
          Offset(currentPosition + dashLength, 0),
          paint,
        );
      } else {
        canvas.drawLine(
          Offset(0, currentPosition),
          Offset(0, currentPosition + dashLength),
          paint,
        );
      }
      currentPosition += dashLength + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
