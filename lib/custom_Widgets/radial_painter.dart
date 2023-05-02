import 'dart:math';

import 'package:flutter/material.dart';

class RadialPainter extends CustomPainter {
  final Color bgColor;
  final List<Color> lineColors;
  final List<double> values;
  final double width;

  RadialPainter({
    required this.bgColor,
    required this.lineColors,
    required this.values,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint bgLine = Paint()
      ..color = bgColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, bgLine);

    double total = values.reduce((a, b) => a + b);
    double startAngle = -pi / 2;

    if (total == 0) {
      Paint defaultLine = Paint()
        ..color = Colors.black
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = width;
      canvas.drawCircle(center, radius, defaultLine);
      return;
    }

    for (int i = 0; i < values.length; i++) {
      double sweepAngle = 2 * pi * (values[i] / total);
      Paint completeLine = Paint()
        ..color = lineColors[i]
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = width;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        completeLine,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
