import 'package:flutter/material.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/dimensions/dimension_app.dart';
import 'package:money/core/extensions/theme_extension.dart';
import 'package:money/features/categories/domain/entities/category.dart';

class CategoryDropdown extends StatelessWidget {
  final List<Category> categories;
  final Category? selectedCategory;
  final ValueChanged<Category?> onChanged;
  final bool isRequired;

  const CategoryDropdown({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Category', style: context.fonts.bodySmall),
            if (!isRequired)
              Text(
                ' (optional)',
                style: context.fonts.bodySmall?.copyWith(
                  color: AppColor.gray,
                  fontSize: 10,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
            borderRadius: BorderRadius.circular(Dimension.circular12),
            border: Border.all(color: AppColor.borderGray),
          ),
          child: categories.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    'No categories available. Add one first.',
                    style: context.fonts.bodyMedium?.copyWith(
                      color: AppColor.gray,
                    ),
                  ),
                )
              : DropdownButtonHideUnderline(
                  child: DropdownButton<Category>(
                    value: selectedCategory,
                    isExpanded: true,
                    dropdownColor: AppColor.bottomNavBarBackGround,
                    style: context.fonts.bodyMedium?.copyWith(
                      color: AppColor.white,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColor.gray,
                    ),
                    items: categories.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Color(
                                  int.parse(cat.color ?? '', radix: 16),
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(cat.name ?? ''),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => onChanged(val),
                  ),
                ),
        ),
        if (isRequired && selectedCategory == null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Category is required for expense',
              style: context.fonts.bodySmall?.copyWith(
                color: AppColor.lightRed,
                fontSize: 10,
              ),
            ),
          ),
      ],
    );
  }
}
