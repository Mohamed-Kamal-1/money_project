import 'package:flutter/material.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/dimensions/dimension_app.dart';
import 'package:money/core/extensions/theme_extension.dart';
import 'package:money/features/analytics/presentation/cubit/analytics_state.dart';

class TopCategories extends StatelessWidget {
  final AnalyticsLoaded analytics;
  final List<Color> _categoryColors = const [
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
    Color(0xFFF59E0B),
    Color(0xFF10B981),
    Color(0xFFEF4444),
    Color(0xFF06B6D4),
    Color(0xFF6366F1),
  ];

  const TopCategories({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    if (analytics.categorySpending.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.bottomNavBarBackGround,
          borderRadius: BorderRadius.circular(Dimension.circular16),
        ),
        child: Center(
          child: Text(
            'No spending data available',
            style: context.fonts.bodyMedium?.copyWith(color: AppColor.gray),
          ),
        ),
      );
    }

    final sortedEntries = analytics.categorySpending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.bottomNavBarBackGround,
        borderRadius: BorderRadius.circular(Dimension.circular16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Spending Categories',
            style: context.fonts.bodySmall?.copyWith(
              color: AppColor.gray,
              fontWeight: FontWeight.w600,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          ...sortedEntries.take(5).map((entry) {
            final percentage = analytics.monthTotal == 0
                ? 0.0
                : (entry.value / analytics.monthTotal) * 100;
            final colorIndex =
                sortedEntries.indexOf(entry) % _categoryColors.length;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: _categoryColors[colorIndex],
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(entry.key, style: context.fonts.bodyMedium),
                        ],
                      ),
                      Text(
                        '\$${entry.value.toStringAsFixed(2)}',
                        style: context.fonts.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      minHeight: 6,
                      backgroundColor: AppColor.borderGray,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _categoryColors[colorIndex],
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: context.fonts.bodySmall?.copyWith(
                      color: AppColor.gray,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
