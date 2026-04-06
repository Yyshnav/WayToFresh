import 'package:flutter/material.dart';

class GoldCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFFFFF9E6) // Light cream/gold
      ..style = PaintingStyle.fill;

    Path path = Path();
    double curveHeight = 20.0;

    // Start top left
    path.moveTo(0, curveHeight);
    // Draw top edge curve (curved down in the middle)
    path.quadraticBezierTo(size.width / 2, -curveHeight, size.width, curveHeight);
    // Right edge
    path.lineTo(size.width, size.height - curveHeight);
    // Bottom edge curve (curved up in the middle)
    path.quadraticBezierTo(size.width / 2, size.height + curveHeight, 0, size.height - curveHeight);
    // Left edge
    path.close();

    canvas.drawShadow(path.shift(const Offset(0, 4)), Colors.black.withOpacity(0.1), 8.0, true);
    canvas.drawPath(path, paint);

    // Draw the "envelope" flap lines
    Paint linePaint = Paint()
      ..color = const Color(0xFFFFE082) // Slightly darker gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    Path flapPath = Path();
    flapPath.moveTo(0, curveHeight);
    flapPath.lineTo(size.width / 2, size.height / 2 + curveHeight);
    flapPath.lineTo(size.width, curveHeight);
    canvas.drawPath(flapPath, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
