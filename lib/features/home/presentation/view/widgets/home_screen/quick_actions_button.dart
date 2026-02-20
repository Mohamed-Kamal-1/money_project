import 'package:flutter/material.dart';

import '../../../../../../../core/dimensions/Dimension_app.dart';
import '../../../../../../../core/extensions/theme_extension.dart';
import '../../../../../../../core/widgets_for_all_app/financial_card.dart';



typedef OnTap = void Function();

class QuickActionsButton extends StatelessWidget {
  final IconData icon;
  final Color iconAndTextColor;
  final Color backgroundColor;
  final String text;
  final OnTap onTap;

  const QuickActionsButton({
    super.key,
    required this.icon,
    required this.iconAndTextColor,
    required this.backgroundColor,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FinancialCard(
        verticalPadding: Dimension.padding19,
        horizontalPadding: Dimension.padding27,
        alignment: .spaceEvenly,
        crossAlignment: CrossAxisAlignment.center,
        height: Dimension.heightCard103,
        color: backgroundColor,
        children: [
          Icon(icon, color: iconAndTextColor, size: Dimension.size24),
          Text(
            text,
            style: context.fonts.bodyMedium?.copyWith(color: iconAndTextColor),
          ),
        ],
      ),
    );
  }
}
