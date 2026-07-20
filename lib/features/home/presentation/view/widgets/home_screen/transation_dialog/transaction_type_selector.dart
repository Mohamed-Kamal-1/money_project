import 'package:flutter/material.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/extensions/theme_extension.dart';

class TransactionTypeSelector extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onTypeChanged;

  const TransactionTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Type', style: context.fonts.bodySmall),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _typeButton(
                context,
                type: 'expense',
                label: 'Expense',
                icon: Icons.arrow_downward,
                color: AppColor.lightRed,
                isSelected: selectedType == 'expense',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _typeButton(
                context,
                type: 'income',
                label: 'Income',
                icon: Icons.arrow_upward,
                color: AppColor.emeraldGreen,
                isSelected: selectedType == 'income',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _typeButton(
    BuildContext context, {
    required String type,
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onTypeChanged(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : AppColor.primaryColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColor.borderGray,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isSelected ? color : AppColor.gray),
            const SizedBox(width: 6),
            Text(
              label,
              style: context.fonts.bodyMedium?.copyWith(
                color: isSelected ? color : AppColor.gray,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
