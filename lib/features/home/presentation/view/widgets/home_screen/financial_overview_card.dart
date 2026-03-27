import 'package:flutter/material.dart';
import '../../../../../../core/colors/app_color.dart';
import '../../../../../../core/dimensions/Dimension_app.dart';
import '../../../../../../core/extensions/theme_extension.dart';
import '../../../../../../core/widgets_for_all_app/financial_card.dart';

class FinancialOverviewCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expenses;
  final VoidCallback onUpdateTap;

  const FinancialOverviewCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expenses,
    required this.onUpdateTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onUpdateTap,
      child: FinancialCard(
        height: Dimension.heightCard245,
        width: double.infinity,
        color: AppColor.darkGreen,
        children: [
          Row(
            children: [
              const Icon(Icons.wallet, size: Dimension.size30, color: AppColor.lightGreen),
              const SizedBox(width: 8),
              Text('Current Balance', style: context.fonts.labelSmall),
              const Spacer(),
              const Icon(Icons.edit, size: 16, color: AppColor.gray),
            ],
          ),
          Text(
            '\$${balance.toStringAsFixed(2)}',
            style: context.fonts.displayMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SmallStatCard(
                  label: 'Income',
                  value: income,
                  labelColor: AppColor.darkTeal,
                ),
              ),
              const SizedBox(width: Dimension.spacing12),
              Expanded(
                child: _SmallStatCard(
                  label: 'Expenses',
                  value: expenses,
                  labelColor: AppColor.lightRed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Private class inside the same file for small reusable parts
class _SmallStatCard extends StatelessWidget {
  final String label;
  final double value;
  final Color labelColor;

  const _SmallStatCard({
    required this.label,
    required this.value,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return FinancialCard(
      alignment: MainAxisAlignment.center,
      borderRadius: Dimension.circular16,
      height: Dimension.heightCard79,
      color: AppColor.secondaryGreen,
      children: [
        Text(label, style: context.fonts.labelSmall?.copyWith(color: labelColor)),
        Text('\$${value.toStringAsFixed(2)}', style: context.fonts.titleMedium),
      ],
    );
  }
}