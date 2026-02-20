import 'package:flutter/material.dart';

import '../../../../../../../core/colors/app_color.dart';
import '../../../../../../../core/dimensions/Dimension_app.dart';
import '../../../../../../../core/extensions/theme_extension.dart';
import '../../../../../../../core/widgets_for_all_app/financial_card.dart';



class FinancialOverviewCard extends StatelessWidget {
  const FinancialOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FinancialCard(
      // spacing: Dimension.spacing8,
      height: Dimension.heightCard245,
      width: double.infinity,
      color: AppColor.darkGreen,
      children: [
        Row(
          spacing: Dimension.spacing8,
          children: [
            const Icon(
              Icons.wallet,
              size: Dimension.size30,
              color: AppColor.lightGreen,
            ),
            Text('Current Balance', style: context.fonts.labelSmall),
          ],
        ),
        Text('\$12,543.75', style: context.fonts.displayMedium),

        Row(
          mainAxisAlignment: .spaceBetween,
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

                color: AppColor.secondaryGreen,
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
        ),
      ],
    );
  }
}
