import 'package:flutter/material.dart';

import '../../../../../../core/colors/app_color.dart';
import '../../../../../../core/dimensions/Dimension_app.dart';
import '../../../../../../core/extensions/theme_extension.dart';
import '../../../../../../core/widgets_for_all_app/financial_card.dart';

class MonthlyExpenseCard extends StatelessWidget {
  const MonthlyExpenseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FinancialCard(
      height: Dimension.heightCard145,
      width: double.infinity,
      verticalPadding: Dimension.spacing16,
      horizontalPadding: Dimension.spacing16,
      color: AppColor.darkOxfordBlue,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('This Month', style: context.fonts.bodyMedium),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimension.spacing8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppColor.deepJungleGreen,
                borderRadius: BorderRadius.circular(Dimension.circular12),
              ),
              child: Text(
                '8.9%',
                style: context.fonts.labelSmall,
              ),
            ),
          ],
        ),
        Text(
          '\$2,847.50',
          style: context.fonts.displayMedium,
        ),
        Text(
          'vs \$3,124.80 last month',
          style: context.fonts.bodyMedium?.copyWith(
            color: AppColor.gray,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
