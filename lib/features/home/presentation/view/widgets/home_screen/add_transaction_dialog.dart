import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/dimensions/dimension_app.dart';
import 'package:money/core/extensions/theme_extension.dart';
import 'package:money/core/widgets_for_all_app/gradient_button.dart';
import 'package:money/features/categories/domain/entities/category.dart';
import 'package:money/features/transaction/domain/entities/transaction.dart';

import '../../../../../transaction/presentation/cubit/transaction/transaction_cubit.dart';
import '../../../../../transaction/presentation/cubit/transaction/transaction_state.dart';

class AddTransactionDialog extends StatefulWidget {
  final String userId;
  final List<Category> categories;

  const AddTransactionDialog({
    required this.userId,
    required this.categories,
    super.key,
  });

  static Future<void> show(
    BuildContext context, {
    required String userId,
    required List<Category> categories,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          AddTransactionDialog(userId: userId, categories: categories),
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

  void _submit() {
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

    final transaction = AppTransaction(
      userId: widget.userId,
      categoryId: _selectedCategory!.id ?? '',
      categoryName: _selectedCategory?.name ?? 'Unknown',
      amount: amount,
      type: _transactionType,
      description: _descriptionController.text,
      date: _selectedDate,
      notes: _noteController.text.isEmpty ? null : _noteController.text,
    );

    context.read<TransactionCubit>().addTransactionWithBalanceUpdate(
      transaction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionCubit, TransactionState>(
      listener: (context, state) {
        if (state is TransactionAdded) {
          Navigator.of(context).pop();
          String message =
              '${_transactionType == 'income' ? 'Income' : 'Expense'} of \$${state.actualAmount.toStringAsFixed(2)} added successfully';
          if (state.wasAdjusted) {
            message =
                'Amount adjusted to \$${state.actualAmount.toStringAsFixed(2)} due to insufficient balance.';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: state.wasAdjusted
                  ? AppColor.amberOrange
                  : AppColor.emeraldGreen,
            ),
          );
        } else if (state is TransactionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColor.lightRed,
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
          child: BlocBuilder<TransactionCubit, TransactionState>(
            builder: (context, state) {
              final isLoading = state is TransactionLoading;
              return SingleChildScrollView(
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
                    Text(
                      'Add Transaction',
                      style: context.fonts.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Type', style: context.fonts.bodySmall),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _transactionType = 'expense'),
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
                            onTap: () =>
                                setState(() => _transactionType = 'income'),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _transactionType == 'income'
                                    ? AppColor.emeraldGreen.withValues(
                                        alpha: 0.15,
                                      )
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
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
                    Text('Category', style: context.fonts.bodySmall),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(
                          Dimension.circular12,
                        ),
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
                                            color: Color(
                                              int.parse(
                                                cat.color ?? '',
                                                radix: 16,
                                              ),
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
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _selectedCategory = val);
                                  }
                                },
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
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
                          borderRadius: BorderRadius.circular(
                            Dimension.circular12,
                          ),
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

                    BlocBuilder<TransactionCubit, TransactionState>(
                      builder: (context, state) {
                        final isLoading = state is TransactionLoading;
                        return GradientButton(
                          text: isLoading
                              ? 'Adding...'
                              : 'Add ${_transactionType == 'income' ? 'Income' : 'Expense'}',
                          onTap: isLoading ? null : _submit,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
