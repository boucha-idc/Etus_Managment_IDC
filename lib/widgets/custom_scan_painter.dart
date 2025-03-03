import 'dart:ui' as ui;

import 'package:flutter/material.dart';


//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
@override
void paint(Canvas canvas, Size size) {

Path path_0 = Path();
path_0.moveTo(129.598,0);
path_0.lineTo(20,0);
path_0.cubicTo(8.95431,0,0,8.9543,0,20);
path_0.lineTo(0,210);
path_0.cubicTo(0,221.046,8.95432,230,20,230);
path_0.lineTo(340,230);
path_0.cubicTo(351.046,230,360,221.046,360,210);
path_0.lineTo(360,20);
path_0.cubicTo(360,8.9543,351.046,0,340,0);
path_0.lineTo(236.201,0);
path_0.cubicTo(231.88,0,227.675,1.39968,224.215,3.98949);
path_0.lineTo(218.726,8.09927);
path_0.cubicTo(215.266,10.6891,211.061,12.0888,206.74,12.0888);
path_0.lineTo(159.939,12.0888);
path_0.cubicTo(156.028,12.0888,152.202,10.9419,148.936,8.79018);
path_0.lineTo(140.6,3.29857);
path_0.cubicTo(137.334,1.14683,133.509,0,129.598,0);
path_0.close();

Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
paint_0_fill.color = Colors.white.withOpacity(1.0);
canvas.drawPath(path_0,paint_0_fill);

}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
return true;
}
}