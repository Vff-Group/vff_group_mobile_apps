import 'package:flutter/material.dart';

class DottedVerticalLine extends StatelessWidget {
  final double height;
  final Color color;

  DottedVerticalLine({this.height = 100.0, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: CustomPaint(
        painter: DottedLinePainter(color: color),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;

  DottedLinePainter({this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    double dashHeight = 5.0;
    double dashSpace = 5.0;
    double startY = 0.0;
    double endY = size.height;

    while (startY < endY) {
      canvas.drawLine(Offset(0.0, startY), Offset(0.0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}