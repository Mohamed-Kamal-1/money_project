import 'package:flutter/material.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/extensions/theme_extension.dart';
import 'package:money/features/analytics/presentation/cubit/analytics_state.dart';

class TotalExpensesCard extends StatelessWidget {
  final AnalyticsLoaded analytics;

  const TotalExpensesCard({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            '\$${analytics.monthTotal.toStringAsFixed(2)}',
            style: context.fonts.displayMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 36,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Total Expenses',
            style: context.fonts.bodyMedium?.copyWith(color: AppColor.gray),
          ),
        ],
      ),
    );
  }
}
