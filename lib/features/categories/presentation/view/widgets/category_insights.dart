import 'package:flutter/material.dart';

import '../../../../../core/colors/app_color.dart';
import '../../../../../core/dimensions/Dimension_app.dart';
import '../../../../../core/extensions/theme_extension.dart';

class CategoryInsights extends StatelessWidget {
  final int totalCategories;
  final double totalBudget;
  final double totalSpent;

  const CategoryInsights({
    super.key,
    required this.totalCategories,
    required this.totalBudget,
    required this.totalSpent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Dimension.spacing12,
      children: [
        Text(
          'Category Insights',
          style: context.fonts.bodyMedium?.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        _InsightRow(
          label: 'Total Categories',
          value: totalCategories.toString(),
          valueColor: AppColor.white,
        ),
        _InsightRow(
          label: 'Total Budget',
          value: '\$${totalBudget.toStringAsFixed(0)}',
          valueColor: AppColor.white,
        ),
        _InsightRow(
          label: 'Total Spent',
          value: '\$${totalSpent.toStringAsFixed(0)}',
          valueColor: AppColor.lightGreen,
        ),
      ],
    );
  }
}

class _InsightRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _InsightRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.fonts.bodyMedium?.copyWith(color: AppColor.gray),
        ),
        Text(
          value,
          style: context.fonts.bodyMedium?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
