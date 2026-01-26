import 'package:flutter/cupertino.dart';

class GradientShapeBorder extends ShapeBorder {
  final LinearGradient gradient;
  final BorderRadius borderRadius;
  final EdgeInsets padding;

  const GradientShapeBorder({
    required this.gradient,
    required this.borderRadius,
    this.padding = EdgeInsets.zero,
  });

  @override
  EdgeInsetsGeometry get dimensions => padding;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.toRRect(rect));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(borderRadius.toRRect(rect), paint);
  }

  @override
  ShapeBorder scale(double t) => this;
}
