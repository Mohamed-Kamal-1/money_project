import 'dart:math';
import 'package:flutter/material.dart';

class DonutChartPainter extends CustomPainter {
  final List<DonutSegment> segments;
  final double strokeWidth;

  DonutChartPainter({required this.segments, this.strokeWidth = 32});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) / 2) - strokeWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -pi / 2;
    const gapAngle = 0.03;

    for (int i = 0; i < segments.length; i++) {
      final sweepAngle = (2 * pi * segments[i].percentage / 100) - gapAngle;
      if (sweepAngle <= 0) continue;

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = segments[i].color;

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(covariant DonutChartPainter oldDelegate) {
    return oldDelegate.segments != segments;
  }
}

class DonutSegment {
  final String label;
  final double percentage;
  final double amount;
  final Color color;

  const DonutSegment({
    required this.label,
    required this.percentage,
    required this.amount,
    required this.color,
  });
}
