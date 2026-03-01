import 'package:flutter/material.dart';
import 'package:money/features/home/domain/models/category_model.dart';

import '../../../../../core/colors/app_color.dart';
import '../../../../../core/dimensions/Dimension_app.dart';
import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/widgets_for_all_app/gradient_button.dart';

class AddCategoryDialog extends StatefulWidget {
  final String userId;
  final void Function(Category category)?
      onCategoryAdded;

  const AddCategoryDialog({
    required this.userId,
    super.key,
    this.onCategoryAdded,
  });

  static Future<void> show(
    BuildContext context, {
    required String userId,
    void Function(Category category)?
        onCategoryAdded,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddCategoryDialog(
        userId: userId,
        onCategoryAdded: onCategoryAdded,
      ),
    );
  }

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _nameController = TextEditingController();
  final _budgetController = TextEditingController();
  IconData _selectedIcon = Icons.category;
  Color _selectedColor = const Color(0xFF3B82F6);
  bool _isLoading = false;

  static const List<IconData> _availableIcons = [
    Icons.restaurant,
    Icons.directions_car,
    Icons.shopping_bag,
    Icons.movie,
    Icons.favorite,
    Icons.bolt,
    Icons.home,
    Icons.school,
    Icons.flight,
    Icons.sports_esports,
    Icons.pets,
    Icons.coffee,
    Icons.music_note,
    Icons.work,
    Icons.fitness_center,
    Icons.local_grocery_store,
    Icons.phone_android,
    Icons.attach_money,
    Icons.child_care,
    Icons.local_hospital,
  ];

  static const List<Color> _availableColors = [
    Color(0xFFFF6B35),
    Color(0xFFEC4899),
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
    Color(0xFFEF4444),
    Color(0xFF3B82F6),
    Color(0xFF34D399),
    Color(0xFFF59E0B),
    Color(0xFF6366F1),
    Color(0xFFE11D48),
    Color(0xFF14B8A6),
    Color(0xFFF97316),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  String _getIconName(IconData icon) {
    // Convert IconData to string identifier
    return icon.codePoint.toString();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final budget = double.tryParse(_budgetController.text);

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a category name'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    if (budget == null || budget <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid budget'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final category = Category(
        userId: widget.userId,
        name: name,
        colorValue: _selectedColor.value,
        iconName: _getIconName(_selectedIcon),
        budget: budget,
      );

      widget.onCategoryAdded?.call(category);
      
      if (!mounted) return;
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Category "$name" created successfully'),
          backgroundColor: AppColor.emeraldGreen,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColor.bottomNavBarBackGround,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColor.gray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'Add Custom Category',
                style: context.fonts.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              // Category name
              Text('Category Name', style: context.fonts.bodySmall),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                style: context.fonts.bodyMedium?.copyWith(
                  color: AppColor.white,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g. Groceries',
                  hintStyle: context.fonts.bodyMedium?.copyWith(
                    color: AppColor.gray,
                  ),
                  filled: true,
                  fillColor: AppColor.primaryColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimension.circular12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimension.circular12),
                    borderSide: const BorderSide(color: AppColor.borderGray),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimension.circular12),
                    borderSide: const BorderSide(color: AppColor.blueStart),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Icon selector
              Text('Icon', style: context.fonts.bodySmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableIcons.map((icon) {
                  final isSelected = icon == _selectedIcon;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = icon),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _selectedColor.withValues(alpha: 0.2)
                            : AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? _selectedColor
                              : AppColor.borderGray,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: isSelected ? _selectedColor : AppColor.gray,
                        size: 20,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Color selector
              Text('Color', style: context.fonts.bodySmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableColors.map((color) {
                  final isSelected = color == _selectedColor;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColor.white
                              : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: AppColor.white,
                              size: 16,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Budget field
              Text('Monthly Budget', style: context.fonts.bodySmall),
              const SizedBox(height: 8),
              TextField(
                controller: _budgetController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: context.fonts.bodyMedium?.copyWith(
                  color: AppColor.white,
                ),
                decoration: InputDecoration(
                  prefixText: '\$ ',
                  prefixStyle: context.fonts.bodyMedium?.copyWith(
                    color: AppColor.white,
                  ),
                  hintText: '0.00',
                  hintStyle: context.fonts.bodyMedium?.copyWith(
                    color: AppColor.gray,
                  ),
                  filled: true,
                  fillColor: AppColor.primaryColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimension.circular12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimension.circular12),
                    borderSide: const BorderSide(color: AppColor.borderGray),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimension.circular12),
                    borderSide: const BorderSide(color: AppColor.blueStart),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Preview
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(Dimension.circular12),
                  border: Border.all(color: AppColor.borderGray),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _selectedColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _selectedIcon,
                        color: AppColor.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _nameController.text.isEmpty
                                ? 'Category Preview'
                                : _nameController.text,
                            style: context.fonts.bodyMedium?.copyWith(
                              color: AppColor.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Budget: \$${_budgetController.text.isEmpty ? "0" : _budgetController.text}',
                            style: context.fonts.bodyMedium?.copyWith(
                              color: AppColor.gray,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Submit
              GradientButton(
                text: _isLoading ? 'Creating...' : 'Create Category',
                onTap: _isLoading ? null : _submit,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
