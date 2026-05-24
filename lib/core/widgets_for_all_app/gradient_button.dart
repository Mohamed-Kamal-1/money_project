import 'package:flutter/material.dart';

import '../colors/app_color.dart';
import '../dimensions/dimension_app.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onTap;
  final double? width;
  final double height;

  const GradientButton({
    super.key,
    required this.text,
    this.icon,
    this.onTap,
    this.width,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          gradient: AppColor.navGradient,
          borderRadius: BorderRadius.circular(Dimension.circular12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: Dimension.spacing8,
          children: [
            if (icon != null)
              Icon(icon, color: AppColor.white, size: Dimension.size24),
            Text(
              text,
              style: const TextStyle(
                color: AppColor.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
