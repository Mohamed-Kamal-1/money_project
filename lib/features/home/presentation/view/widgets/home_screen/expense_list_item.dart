import 'package:flutter/material.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/dimensions/Dimension_app.dart';
import 'package:money/core/extensions/theme_extension.dart';
import 'package:money/features/expense/model/expense_model.dart';

class ExpenseListItem extends StatelessWidget {
  final ExpenseModel expense;

  const ExpenseListItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimension.spacing12),
      padding: const EdgeInsets.all(Dimension.padding12),
      decoration: BoxDecoration(
        color: AppColor.darkMidnightBlue,
        borderRadius: BorderRadius.circular(Dimension.circular12),
        border: Border.all(color: AppColor.inputFieldBorder, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColor.cardBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getCategoryIcon(expense.category),
              color: AppColor.softLavender,
              size: 20,
            ),
          ),
          const SizedBox(width: Dimension.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.merchant,
                  style: context.fonts.bodyMedium?.copyWith(
                    color: AppColor.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  expense.category,
                  style: context.fonts.bodySmall?.copyWith(
                    color: AppColor.gray,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '-\$${expense.amount.toStringAsFixed(2)}',
                style: context.fonts.bodyMedium?.copyWith(
                  color: AppColor.lightRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _formatDate(expense.date),
                style: context.fonts.bodySmall?.copyWith(
                  color: AppColor.gray,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food & Dining':
        return Icons.restaurant_outlined;
      case 'Transport':
        return Icons.directions_car_outlined;
      case 'Shopping':
        return Icons.shopping_bag_outlined;
      case 'Entertainment':
        return Icons.movie_outlined;
      case 'Health':
        return Icons.favorite_outline;
      case 'Utilities':
        return Icons.bolt_outlined;
      default:
        return Icons.money_off;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
