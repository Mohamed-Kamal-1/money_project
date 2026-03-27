import 'dart:math';
import 'package:flutter/material.dart';

import 'dart:math';
import 'package:flutter/material.dart';

class DonutChartPainter extends CustomPainter {
  final List<DonutSegment> segments;
  final double strokeWidth;

  DonutChartPainter({required this.segments, this.strokeWidth = 32});

  @override
  void paint(Canvas canvas, Size size) {
    if (segments.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) / 2) - strokeWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -pi / 2; // البدء من الأعلى (الساعة 12)
    const gapAngle = 0.03; // الفراغ بين القطاعات

    for (int i = 0; i < segments.length; i++) {
      // حساب زاوية القطاع بناءً على نسبته، مع طرح الفراغ لو كان هناك أكثر من قطاع
      final sweepAngle = (2 * pi * segments[i].percentage / 100) - (segments.length > 1 ? gapAngle : 0);

      if (sweepAngle <= 0) continue;

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round // الحواف الدائرية (الاحترافية)
        ..color = segments[i].color;

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);

      // تحديث زاوية البداية للقطاع القادم
      startAngle += sweepAngle + (segments.length > 1 ? gapAngle : 0);
    }
  }

  @override
  bool shouldRepaint(covariant DonutChartPainter oldDelegate) => oldDelegate.segments != segments;
}

class DonutSegment {
  final String label;      // الاسم (الفئة)
  final double percentage; // النسبة المئوية
  final double amount;     // القيمة المادية
  final Color color;       // لون القطاع

  const DonutSegment({
    required this.label,
    required this.percentage,
    required this.amount,
    required this.color,
  });
}