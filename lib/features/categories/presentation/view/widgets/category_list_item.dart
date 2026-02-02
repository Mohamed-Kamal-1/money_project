import 'package:flutter/material.dart';

import '../../../../../core/colors/app_color.dart';
import '../../../../../core/dimensions/Dimension_app.dart';
import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/widgets_for_all_app/custom_linear_indicator.dart';

class CategoryListItem extends StatelessWidget {
  final IconData icon;
  final Color iconBackgroundColor;
  final String categoryName;
  final double spent;
  final double budget;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CategoryListItem({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.categoryName,
    required this.spent,
    required this.budget,
    this.onEdit,
    this.onDelete,
  });

  double get progress => budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;
  double get remaining => (budget - spent).clamp(0.0, double.infinity);
  int get percentUsed => (progress * 100).round();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimension.padding12),
      decoration: BoxDecoration(
        color: AppColor.darkOxfordBlue,
        borderRadius: BorderRadius.circular(Dimension.circular16),
      ),
      child: Column(
        spacing: Dimension.spacing8,
        children: [
          // Header row: icon, name, budget, action buttons
          Row(
            children: [
              // Category Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(Dimension.circular12),
                ),
                child: Icon(icon, color: AppColor.white, size: 20),
              ),
              const SizedBox(width: Dimension.spacing12),
              // Name and Budget
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryName,
                      style: context.fonts.bodyMedium?.copyWith(
                        color: AppColor.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '\$${spent.toStringAsFixed(0)} / \$${budget.toStringAsFixed(0)}',
                      style: context.fonts.bodyMedium?.copyWith(
                        color: AppColor.gray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Action buttons
              _ActionButton(
                icon: Icons.check,
                backgroundColor: AppColor.blueStart,
                onTap: onEdit,
              ),
              const SizedBox(width: Dimension.spacing8),
              _ActionButton(
                icon: Icons.square_rounded,
                backgroundColor: AppColor.redCategory,
                onTap: onDelete,
              ),
            ],
          ),
          // Progress bar row
          Row(
            children: [
              Expanded(
                child: CustomPaint(
                  size: const Size(double.infinity, 4),
                  painter: CustomLinearIndicator(
                    progress: progress,
                    backgroundColor: AppColor.spaceBlue,
                    gradientColors: [
                      iconBackgroundColor,
                      iconBackgroundColor.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$percentUsed% used',
                style: context.fonts.bodyMedium?.copyWith(
                  color: AppColor.gray,
                  fontSize: 11,
                ),
              ),
              Text(
                '\$${remaining.toStringAsFixed(0)} left',
                style: context.fonts.bodyMedium?.copyWith(
                  color: AppColor.gray,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: AppColor.white, size: 14),
      ),
    );
  }
}
