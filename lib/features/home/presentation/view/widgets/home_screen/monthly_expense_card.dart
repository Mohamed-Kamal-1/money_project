import 'package:flutter/material.dart';
import '../../../../../../core/colors/app_color.dart';
import '../../../../../../core/dimensions/Dimension_app.dart';
import '../../../../../../core/extensions/theme_extension.dart';
import '../../../../../../core/widgets_for_all_app/financial_card.dart';

class MonthlyExpenseCard extends StatelessWidget {
  final double currentMonthExpenses;
  final double lastMonthExpenses;

  const MonthlyExpenseCard({
    super.key,
    required this.currentMonthExpenses,
    required this.lastMonthExpenses,
  });

  @override
  Widget build(BuildContext context) {
    // حساب نسبة التغير ديناميكيًا
    double percentageChange = 0;
    if (lastMonthExpenses > 0) {
      percentageChange = ((currentMonthExpenses - lastMonthExpenses) / lastMonthExpenses) * 100;
    }

    final bool isIncreased = currentMonthExpenses > lastMonthExpenses;

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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                // اللون يتغير أحمر لو المصاريف زادت، أخضر لو قلت
                color: isIncreased ? AppColor.lightRed.withOpacity(0.2) : AppColor.deepJungleGreen,
                borderRadius: BorderRadius.circular(Dimension.circular12),
              ),
              child: Text(
                '${percentageChange.abs().toStringAsFixed(1)}%',
                style: context.fonts.labelSmall?.copyWith(
                  color: isIncreased ? AppColor.lightRed : AppColor.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Dimension.spacing8),
        Text(
          '\$${currentMonthExpenses.toStringAsFixed(2)}',
          style: context.fonts.displayMedium,
        ),
        Text(
          'vs \$${lastMonthExpenses.toStringAsFixed(2)} last month',
          style: context.fonts.bodyMedium?.copyWith(
            color: AppColor.gray,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}