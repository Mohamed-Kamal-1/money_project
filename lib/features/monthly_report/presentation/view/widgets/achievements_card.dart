import 'package:flutter/material.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/dimensions/dimension_app.dart';
import 'package:money/core/extensions/theme_extension.dart';
import 'package:money/features/analytics/presentation/cubit/analytics_state.dart';

class AchievementsCard extends StatelessWidget {
  final AnalyticsLoaded analytics;

  const AchievementsCard({super.key, required this.analytics});

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
          Text(
            'Achievements This Month',
            style: context.fonts.bodySmall?.copyWith(
              color: AppColor.gray,
              fontWeight: FontWeight.w600,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColor.borderGray),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColor.emeraldGreen,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Budget Goal Met',
                      style: context.fonts.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${analytics.percentageChange > 0 ? '+' : ''}${analytics.percentageChange.toStringAsFixed(1)}% ${analytics.percentageChange > 0 ? 'Increase' : 'Decrease'}',
                  style: context.fonts.bodyMedium?.copyWith(
                    color: analytics.percentageChange > 0
                        ? AppColor.lightRed
                        : AppColor.emeraldGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
