import 'package:flutter/material.dart';

import '../../../../../../core/colors/app_color.dart';
import '../../../../../../core/dimensions/Dimension_app.dart';
import '../../../../../../core/extensions/theme_extension.dart';

class SpendingSummaryCards extends StatelessWidget {
  final double dailyAverage;
  final int daysTracked;
  final String topCategory;
  final double topCategoryPercent;

  const SpendingSummaryCards({
    super.key,
    required this.dailyAverage,
    required this.daysTracked,
    required this.topCategory,
    required this.topCategoryPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Dimension.spacing12,
      children: [
        // Daily Average card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(Dimension.circular16),
              border: Border.all(
                color: AppColor.borderGray.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Average',
                  style: context.fonts.bodySmall?.copyWith(
                    color: AppColor.emeraldGreen,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${dailyAverage.toStringAsFixed(2)}',
                  style: context.fonts.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Based on $daysTracked days',
                  style: context.fonts.bodyMedium?.copyWith(
                    color: AppColor.gray,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Most Spent On card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E1533), Color(0xFF2D1B69)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(Dimension.circular16),
              border: Border.all(
                color: AppColor.borderGray.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Most Spent On',
                  style: context.fonts.bodySmall?.copyWith(
                    color: AppColor.purpleEnd,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  topCategory,
                  style: context.fonts.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${topCategoryPercent.toStringAsFixed(1)}% of total',
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
