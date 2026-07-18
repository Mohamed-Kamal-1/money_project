import 'package:flutter/material.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/dimensions/dimension_app.dart';
import 'package:money/core/extensions/theme_extension.dart';
import 'package:money/features/analytics/presentation/cubit/analytics_state.dart';

class ComparisonRow extends StatelessWidget {
  final AnalyticsLoaded analytics;
  final DateTime selectedMonth;

  const ComparisonRow({
    super.key,
    required this.analytics,
    required this.selectedMonth,
  });

  @override
  Widget build(BuildContext context) {
    final percentageChange = analytics.percentageChange;
    final isIncrease = percentageChange > 0;
    final savedAmount = ((percentageChange.abs() / 100) * analytics.monthTotal);
    final daysInMonth = DateTime(
      selectedMonth.year,
      selectedMonth.month + 1,
      0,
    ).day;

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.bottomNavBarBackGround,
              borderRadius: BorderRadius.circular(Dimension.circular16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isIncrease ? Icons.trending_up : Icons.trending_down,
                      size: 14,
                      color: isIncrease
                          ? AppColor.lightRed
                          : AppColor.emeraldGreen,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'VS LAST MONTH',
                      style: context.fonts.bodySmall?.copyWith(
                        color: AppColor.gray,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${percentageChange > 0 ? '+' : ''}${percentageChange.toStringAsFixed(1)}%',
                  style: context.fonts.headlineSmall?.copyWith(
                    color: isIncrease
                        ? AppColor.lightRed
                        : AppColor.emeraldGreen,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isIncrease
                      ? 'Spending increased by \$${savedAmount.toStringAsFixed(2)}'
                      : 'Saved \$${savedAmount.toStringAsFixed(2)}',
                  style: context.fonts.bodyMedium?.copyWith(
                    color: AppColor.gray,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.bottomNavBarBackGround,
              borderRadius: BorderRadius.circular(Dimension.circular16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.attach_money,
                      size: 14,
                      color: AppColor.blueStart,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'DAILY AVERAGE',
                      style: context.fonts.bodySmall?.copyWith(
                        color: AppColor.gray,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${analytics.dailyAverage.toStringAsFixed(2)}',
                  style: context.fonts.headlineSmall?.copyWith(
                    color: AppColor.blueStart,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$daysInMonth days tracked',
                  style: context.fonts.bodyMedium?.copyWith(
                    color: AppColor.gray,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
