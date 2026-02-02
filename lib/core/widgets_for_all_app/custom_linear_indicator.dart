import 'package:flutter/cupertino.dart';

class CustomLinearIndicator extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final List<Color> gradientColors;
  

  CustomLinearIndicator({
    required this.progress,
    required this.backgroundColor,
    required this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint();
    bgPaint.color = backgroundColor;
    bgPaint.style = PaintingStyle.fill;
    final rect = Offset.zero & size;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      bgPaint,
    );

    final progressWidth = size.width * progress;
    final progressRect = Offset.zero & Size(progressWidth, size.height);

    final progressPaint = Paint()
      ..shader =
          LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(
            progressRect,
          ) // الـ Shader بيترسم فقط على حجم الجزء الملون
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(progressRect, const Radius.circular(8)),
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomLinearIndicator oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
