import 'dart:math';
import 'package:flutter/material.dart';

/// Custom Painters for Native Livestock and AI AgriTech Graphic Illustrations
class IndigenousCowPainter extends CustomPainter {
  final Color primaryColor;
  final Color accentColor;

  IndigenousCowPainter({
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final accentPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path();
    final width = size.width;
    final height = size.height;

    // Body contour (Distinct hump characteristic of indigenous Indian cattle like Gir/Sahiwal)
    path.moveTo(width * 0.1, height * 0.65);
    // Hump curve
    path.cubicTo(
      width * 0.25, height * 0.3,
      width * 0.45, height * 0.15,
      width * 0.55, height * 0.35,
    );
    // Head & Horns curve
    path.cubicTo(
      width * 0.65, height * 0.3,
      width * 0.75, height * 0.2,
      width * 0.85, height * 0.4,
    );
    // Dewlap & Chest
    path.cubicTo(
      width * 0.9, height * 0.6,
      width * 0.7, height * 0.85,
      width * 0.5, height * 0.8,
    );
    // Back legs & Tail
    path.cubicTo(
      width * 0.3, height * 0.85,
      width * 0.1, height * 0.8,
      width * 0.1, height * 0.65,
    );
    path.close();

    canvas.drawPath(path, paint);

    // Decorative Gold Collar & Tag (Signifying AI Smart RFID Tag)
    canvas.drawCircle(Offset(width * 0.72, height * 0.55), width * 0.05, accentPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class IndigenousGoatPainter extends CustomPainter {
  final Color color;

  IndigenousGoatPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(w * 0.2, h * 0.7);
    path.quadraticBezierTo(w * 0.3, h * 0.4, w * 0.5, h * 0.4);
    path.quadraticBezierTo(w * 0.6, h * 0.2, w * 0.75, h * 0.3); // Curved Horn
    path.quadraticBezierTo(w * 0.8, h * 0.6, w * 0.6, h * 0.8);
    path.quadraticBezierTo(w * 0.4, h * 0.85, w * 0.2, h * 0.7);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AiNodesPainter extends CustomPainter {
  final Color nodeColor;
  final Color lineColor;

  AiNodesPainter({
    required this.nodeColor,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor.withOpacity(0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final nodePaint = Paint()
      ..color = nodeColor
      ..style = PaintingStyle.fill;

    final points = [
      Offset(size.width * 0.2, size.height * 0.3),
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.4),
      Offset(size.width * 0.35, size.height * 0.7),
      Offset(size.width * 0.7, size.height * 0.75),
    ];

    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        canvas.drawLine(points[i], points[j], linePaint);
      }
    }

    for (final point in points) {
      canvas.drawCircle(point, 6, nodePaint);
      canvas.drawCircle(point, 10, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
