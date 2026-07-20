import 'package:flutter/material.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/dimensions/dimension_app.dart';
import 'package:money/core/extensions/theme_extension.dart';

class HistorySummaryBar extends StatelessWidget {
  final double totalIncome;
  final double totalExpenses;
  final double total;

  const HistorySummaryBar({
    super.key,
    required this.totalIncome,
    required this.totalExpenses,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimension.padding16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColor.bottomNavBarBackGround,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(Dimension.padding16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem(context, 'Income', totalIncome, AppColor.emeraldGreen),
          Container(width: 1, height: 30, color: AppColor.borderGray),
          _summaryItem(context, 'Expenses', totalExpenses, AppColor.lightRed),
          Container(width: 1, height: 30, color: AppColor.borderGray),
          _summaryItem(context, 'Total', total, AppColor.blueStart),
        ],
      ),
    );
  }

  Widget _summaryItem(
    BuildContext context,
    String label,
    double amount,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: context.fonts.bodySmall?.copyWith(
            color: AppColor.gray,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: context.fonts.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
