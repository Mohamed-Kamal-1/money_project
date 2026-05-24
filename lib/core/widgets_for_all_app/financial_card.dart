import 'package:flutter/material.dart';
import 'package:money/core/dimensions/dimension_app.dart';

import '../dimensions/radius_app.dart';

class FinancialCard extends StatelessWidget {
  final double? width;
  final double? height;
  final List<Widget> children;
  final Color color;
  final double spacing;
  final double borderRadius;
  final double horizontalPadding;
  final double verticalPadding;
  final CrossAxisAlignment crossAlignment;

  final MainAxisAlignment alignment;

  const FinancialCard({
    super.key,
    this.width,
    this.height,
    required this.children,
    required this.color,
    this.spacing = Dimension.spacing8,
    this.borderRadius = RadiusApp.circular32,
    this.horizontalPadding = Dimension.padding16,
    this.verticalPadding = 0.0,
    this.alignment = MainAxisAlignment.spaceEvenly,
    this.crossAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: ((horizontalPadding == 16.0 && verticalPadding == 0.0))
          ? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0)
          : EdgeInsets.only(
              left: horizontalPadding,
              right: horizontalPadding,
              top: verticalPadding,
              bottom: verticalPadding,
            ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAlignment,
        mainAxisAlignment: alignment,
        spacing: spacing,
        children: children,
      ),
    );
  }
}
