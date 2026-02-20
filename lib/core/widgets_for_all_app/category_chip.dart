import 'package:flutter/material.dart';

import '../colors/app_color.dart';
import '../dimensions/Dimension_app.dart';

class CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color selectedColor;

  const CategoryChip({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.selectedColor = AppColor.amberOrange,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimension.padding12,
          vertical: Dimension.padding8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : AppColor.cardBackground,
          borderRadius: BorderRadius.circular(Dimension.circular12),
          border: Border.all(
            color: isSelected ? selectedColor : AppColor.inputFieldBorder,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: Dimension.spacing8,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColor.primaryColor : AppColor.gray,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColor.primaryColor : AppColor.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
