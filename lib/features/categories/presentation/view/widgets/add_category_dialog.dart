import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/colors/app_color.dart';
import '../../../../../core/dimensions/dimension_app.dart';
import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/widgets_for_all_app/gradient_button.dart';
import '../../../domain/entities/category.dart';
import '../../cubit/category_cubit.dart';
import '../../cubit/category_state.dart';

class AddCategoryDialog extends StatefulWidget {
  final String userId;

  const AddCategoryDialog({required this.userId, super.key});

  static Future<void> show(BuildContext context, {required String userId}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddCategoryDialog(userId: userId),
    );
  }

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _nameController = TextEditingController();
  final _budgetController = TextEditingController();

  // تعديل: الإيموجي الافتراضي هو الرمز المالي
  String _selectedEmoji = '💰';
  Color _selectedColor = const Color(0xFF3B82F6);

  // قائمة الإيموجيز المناسبة لتتبع المصاريف والنفقات
  static const List<String> _availableEmojis = [
    '🍔',
    '🚗',
    '🛍️',
    '🎬',
    '❤️',
    '⚡',
    '🏠',
    '🎓',
    '✈️',
    '🎮',
    '🐱',
    '☕',
    '🎵',
    '💼',
    '🏋️',
    '🛒',
    '📱',
    '💰',
    '👶',
    '🏥',
    '🎁',
    '💈',
    '🔒',
    '📶',
    '🔧',
    '🍕',
    '🥦',
    '👟',
    '🍿',
    '💡',
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

  void _submit() {
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

    final category = Category(
      userId: widget.userId,
      name: name,
      icon: _selectedEmoji, // حفظ الإيموجي كنص مباشرة في الداتابيز
      color: _selectedColor.value.toRadixString(16),
      type: 'expense',
      budget: budget,
      createdAt: DateTime.now(),
    );

    context.read<CategoryCubit>().addCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryCubit, CategoryState>(
      listener: (context, state) {
        if (state is CategoryAdded) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Category "${_nameController.text.trim()}" created successfully',
              ),
              backgroundColor: AppColor.emeraldGreen,
            ),
          );
        } else if (state is CategoryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: const Color(0xFFEF4444),
            ),
          );
        }
      },
      child: Padding(
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
            child: BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, state) {
                final isLoading = state is CategoryLoading;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Text(
                      'Add Custom Category',
                      style: context.fonts.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
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
                          borderRadius: BorderRadius.circular(
                            Dimension.circular12,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Dimension.circular12,
                          ),
                          borderSide: const BorderSide(
                            color: AppColor.borderGray,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Dimension.circular12,
                          ),
                          borderSide: const BorderSide(
                            color: AppColor.blueStart,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Select Emoji', style: context.fonts.bodySmall),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableEmojis.map((emoji) {
                        final isSelected = emoji == _selectedEmoji;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedEmoji = emoji),
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
                            child: Center(
                              child: Text(
                                emoji,
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
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
                          borderRadius: BorderRadius.circular(
                            Dimension.circular12,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Dimension.circular12,
                          ),
                          borderSide: const BorderSide(
                            color: AppColor.borderGray,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Dimension.circular12,
                          ),
                          borderSide: const BorderSide(
                            color: AppColor.blueStart,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(
                          Dimension.circular12,
                        ),
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
                            child: Center(
                              child: Text(
                                _selectedEmoji,
                                style: const TextStyle(fontSize: 20),
                              ),
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
                    GradientButton(
                      text: isLoading ? 'Creating...' : 'Create Category',
                      onTap: isLoading ? null : _submit,
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
