import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/dimensions/Dimension_app.dart';
import 'package:money/core/extensions/theme_extension.dart';
import 'package:money/core/widgets_for_all_app/gradient_button.dart';
import 'package:money/features/home/domain/models/category_model.dart';
import 'package:money/features/home/domain/models/transaction_model.dart';

class AddTransactionDialog extends StatefulWidget {
  final String userId;
  final List<Category> categories;
  final Function(AppTransaction) onTransactionAdded;

  const AddTransactionDialog({
    required this.userId,
    required this.categories,
    required this.onTransactionAdded,
    super.key,
  });

  static Future<void> show(
    BuildContext context, {
    required String userId,
    required List<Category> categories,
    required Function(AppTransaction) onTransactionAdded,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTransactionDialog(
        userId: userId,
        categories: categories,
        onTransactionAdded: onTransactionAdded,
      ),
    );
  }

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _noteController;
  late DateTime _selectedDate;
  Category? _selectedCategory;
  String _transactionType = 'expense'; // 'income' or 'expense'
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _descriptionController = TextEditingController();
    _noteController = TextEditingController();
    _selectedDate = DateTime.now();
    if (widget.categories.isNotEmpty) {
      _selectedCategory = widget.categories.first;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColor.blueStart,
              surface: AppColor.bottomNavBarBackGround,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a description'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final transaction = AppTransaction(
        userId: widget.userId,
        categoryId: _selectedCategory!.id ?? '',
        categoryName: _selectedCategory!.name,
        amount: amount,
        type: _transactionType,
        description: _descriptionController.text,
        date: _selectedDate,
        notes: _noteController.text.isEmpty ? null : _noteController.text,
      );

      // Call the callback to add transaction
      widget.onTransactionAdded(transaction);

      if (!mounted) return;
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${_transactionType == 'income' ? 'Income' : 'Expense'} of \$${amount.toStringAsFixed(2)} added to ${_selectedCategory!.name}',
          ),
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
                'Add Transaction',
                style: context.fonts.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              // Transaction Type Toggle
              Text('Type', style: context.fonts.bodySmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _transactionType = 'expense'),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _transactionType == 'expense'
                              ? AppColor.lightRed.withValues(alpha: 0.15)
                              : AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _transactionType == 'expense'
                                ? AppColor.lightRed
                                : AppColor.borderGray,
                            width: _transactionType == 'expense' ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_downward,
                              size: 18,
                              color: _transactionType == 'expense'
                                  ? AppColor.lightRed
                                  : AppColor.gray,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Expense',
                              style: context.fonts.bodyMedium?.copyWith(
                                color: _transactionType == 'expense'
                                    ? AppColor.lightRed
                                    : AppColor.gray,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _transactionType = 'income'),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _transactionType == 'income'
                              ? AppColor.emeraldGreen.withValues(alpha: 0.15)
                              : AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _transactionType == 'income'
                                ? AppColor.emeraldGreen
                                : AppColor.borderGray,
                            width: _transactionType == 'income' ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_upward,
                              size: 18,
                              color: _transactionType == 'income'
                                  ? AppColor.emeraldGreen
                                  : AppColor.gray,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Income',
                              style: context.fonts.bodyMedium?.copyWith(
                                color: _transactionType == 'income'
                                    ? AppColor.emeraldGreen
                                    : AppColor.gray,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Amount field
              Text('Amount', style: context.fonts.bodySmall),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: context.fonts.headlineSmall,
                decoration: InputDecoration(
                  prefixText: '\$ ',
                  prefixStyle: context.fonts.headlineSmall,
                  hintText: '0.00',
                  hintStyle: context.fonts.headlineSmall?.copyWith(
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
              const SizedBox(height: 16),

              // Description field
              Text('Description', style: context.fonts.bodySmall),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                style: context.fonts.bodyMedium?.copyWith(
                  color: AppColor.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter description',
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
              const SizedBox(height: 16),

              // Category selector
              Text('Category', style: context.fonts.bodySmall),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(Dimension.circular12),
                  border: Border.all(color: AppColor.borderGray),
                ),
                child: widget.categories.isEmpty
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
                          value: _selectedCategory,
                          isExpanded: true,
                          dropdownColor: AppColor.bottomNavBarBackGround,
                          style: context.fonts.bodyMedium?.copyWith(
                            color: AppColor.white,
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColor.gray,
                          ),
                          items: widget.categories.map((cat) {
                            return DropdownMenuItem(
                              value: cat,
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: cat.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(cat.name),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedCategory = val);
                            }
                          },
                        ),
                      ),
              ),
              const SizedBox(height: 16),

              // Date picker
              Text('Date', style: context.fonts.bodySmall),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.circular(Dimension.circular12),
                    border: Border.all(color: AppColor.borderGray),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMM dd, yyyy').format(_selectedDate),
                        style: context.fonts.bodyMedium?.copyWith(
                          color: AppColor.white,
                        ),
                      ),
                      const Icon(
                        Icons.calendar_today,
                        color: AppColor.gray,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Note field
              Text('Note (optional)', style: context.fonts.bodySmall),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                style: context.fonts.bodyMedium?.copyWith(
                  color: AppColor.white,
                ),
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Add a note...',
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

              // Submit button
              GradientButton(
                text: _isLoading
                    ? 'Adding...'
                    : 'Add ${_transactionType == 'income' ? 'Income' : 'Expense'}',
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
