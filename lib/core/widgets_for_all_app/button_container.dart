import 'package:flutter/material.dart';

import '../colors/app_color.dart';
import '../dimensions/Dimension_app.dart';
import '../extensions/theme_extension.dart';
import 'financial_card.dart';

class ButtonContainer extends StatelessWidget {
  final MainAxisAlignment mainAxisAlignment;

  const ButtonContainer({super.key, required this.mainAxisAlignment});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      spacing: Dimension.spacing12,
      children: [
        Expanded(
          child: FinancialCard(
            spacing: Dimension.spacing8,
            alignment: MainAxisAlignment.center,
            borderRadius: Dimension.circular16,
            // spacing: Dimension.spacing8,
            height: Dimension.heightCard79,

            color: const Color(0xFF0F3D36),
            children: [
              Text(
                textAlign: TextAlign.start,
                'Income',
                style: context.fonts.labelSmall?.copyWith(
                  color: AppColor.darkTeal,
                ),
              ),
              Text(
                textAlign: TextAlign.end,
                '\$5,400.00',
                style: context.fonts.titleMedium,
              ),
            ],
          ),
        ),
        Expanded(
          child: FinancialCard(
            spacing: Dimension.spacing8,
            alignment: MainAxisAlignment.center,
            borderRadius: Dimension.circular16,
            // spacing: Dimension.spacing8,
            height: Dimension.heightCard79,

            color: AppColor.secondaryGreen,
            children: [
              Text(
                'Expenses',
                style: context.fonts.labelSmall?.copyWith(
                  color: AppColor.lightRed,
                ),
              ),
              Text(
                '\$2,847.50',
                style: context.fonts.titleMedium?.copyWith(
                  color: AppColor.lightRed,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
