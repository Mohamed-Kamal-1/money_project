import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/extensions/theme_extension.dart';
import 'package:money/features/categories/domain/entities/category.dart';
import 'package:money/features/home/presentation/view/widgets/home_screen/transation_dialog/submit_button.dart';
import 'package:money/features/home/presentation/view/widgets/home_screen/transation_dialog/transaction_type_selector.dart';
import 'package:money/features/transaction/domain/entities/transaction.dart';
import 'package:money/features/transaction/presentation/cubit/transaction/transaction_cubit.dart';
import 'package:money/features/transaction/presentation/cubit/transaction/transaction_state.dart';

import 'amount_field.dart';
import 'category_dropdown.dart';
import 'date_picker.dart';
import 'description_field.dart';
import 'note_field.dart';

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
  String _transactionType = 'expense';

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

  void _submit() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }

    if (_descriptionController.text.isEmpty) {
      _showError('Please enter a description');
      return;
    }

    // ✅ الفئة إجبارية فقط للمصروفات
    if (_transactionType == 'expense' && _selectedCategory == null) {
      _showError('Please select a category for expense');
      return;
    }

    final transaction = AppTransaction(
      userId: widget.userId,
      categoryId: _selectedCategory?.id ?? '',
      categoryName: _selectedCategory?.name ?? 'Income',
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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColor.lightRed),
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
                      'Add Transaction',
                      style: context.fonts.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Type Selector
                    TransactionTypeSelector(
                      selectedType: _transactionType,
                      onTypeChanged: (type) {
                        setState(() {
                          _transactionType = type;
                          // إذا تغير النوع إلى income ولا توجد فئة محددة، نضبطها على null
                          if (type == 'income') {
                            _selectedCategory = null;
                          } else if (widget.categories.isNotEmpty &&
                              _selectedCategory == null) {
                            _selectedCategory = widget.categories.first;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Amount Field
                    AmountField(controller: _amountController),
                    const SizedBox(height: 16),

                    // Description Field
                    DescriptionField(controller: _descriptionController),
                    const SizedBox(height: 16),

                    // Category Dropdown (required only for expense)
                    CategoryDropdown(
                      categories: widget.categories,
                      selectedCategory: _selectedCategory,
                      onChanged: (category) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      isRequired: _transactionType == 'expense',
                    ),
                    const SizedBox(height: 16),

                    // Date Picker
                    DatePicker(
                      selectedDate: _selectedDate,
                      onDateChanged: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Note Field
                    NoteField(controller: _noteController),
                    const SizedBox(height: 24),

                    // Submit Button
                    SubmitButton(
                      isLoading: isLoading,
                      transactionType: _transactionType,
                      onPressed: _submit,
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
