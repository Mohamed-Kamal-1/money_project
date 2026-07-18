import 'package:flutter/material.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/dimensions/dimension_app.dart';
import 'package:money/core/extensions/theme_extension.dart';
import 'package:money/features/analytics/presentation/cubit/analytics_state.dart';

class SpendingBehavior extends StatelessWidget {
  final AnalyticsLoaded analytics;

  const SpendingBehavior({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                Icons.lightbulb,
                color: AppColor.yellowAccent,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Spending Behavior',
                style: context.fonts.bodySmall?.copyWith(
                  color: AppColor.gray,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            analytics.spendingBehavior.isEmpty
                ? 'Add transactions to see insights'
                : analytics.spendingBehavior,
            style: context.fonts.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
