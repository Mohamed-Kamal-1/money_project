import 'dart:math';
import 'package:flutter/material.dart';

import '../../../../../../core/colors/app_color.dart';

class SpendingTrendPainter extends CustomPainter {
  final List<TrendPoint> points;
  final Color lineColor;
  final Color gridColor;

  SpendingTrendPainter({
    required this.points,
    this.lineColor = const Color(0xFF3B82F6),
    this.gridColor = const Color(0xFF2D3748),
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final maxValue = points.map((p) => p.value).reduce(max);
    final minValue = 0.0;
    final valueRange = maxValue - minValue;
    final padding = 40.0;
    final chartWidth = size.width - padding;
    final chartHeight = size.height - 30;

    // Draw grid lines
    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = gridColor;

    final gridValues = [0, 800, 1600, 2400, 3200];
    final gridTextStyle = TextStyle(color: AppColor.gray, fontSize: 10);

    for (final gridVal in gridValues) {
      final y = chartHeight - (gridVal / (maxValue * 1.1)) * chartHeight;
      canvas.drawLine(Offset(padding, y), Offset(size.width, y), gridPaint);

      final textSpan = TextSpan(text: '$gridVal', style: gridTextStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(0, y - 6));
    }

    // Calculate points positions
    final pointPositions = <Offset>[];
    for (int i = 0; i < points.length; i++) {
      final x = padding + (i / (points.length - 1)) * chartWidth;
      final y =
          chartHeight -
          ((points[i].value - minValue) / (valueRange * 1.2)) * chartHeight;
      pointPositions.add(Offset(x, y));
    }

    // Draw line
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = lineColor
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(pointPositions.first.dx, pointPositions.first.dy);
    for (int i = 1; i < pointPositions.length; i++) {
      path.lineTo(pointPositions[i].dx, pointPositions[i].dy);
    }
    canvas.drawPath(path, linePaint);

    // Draw dots
    final dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;
    final dotBorderPaint = Paint()
      ..color = AppColor.bottomNavBarBackGround
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (final pos in pointPositions) {
      canvas.drawCircle(pos, 5, dotPaint);
      canvas.drawCircle(pos, 5, dotBorderPaint);
    }

    // Draw month labels
    for (int i = 0; i < points.length; i++) {
      final textSpan = TextSpan(text: points[i].label, style: gridTextStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(pointPositions[i].dx - textPainter.width / 2, chartHeight + 10),
      );
    }
  }

  @override
  bool shouldRepaint(covariant SpendingTrendPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class TrendPoint {
  final int day;
  final double value;
  final String label;

  const TrendPoint({required this.day, required this.value, this.label = ''});
}
