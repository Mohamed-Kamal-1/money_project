import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/colors/app_color.dart';
import '../../../../core/dimensions/Dimension_app.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/widgets_for_all_app/category_chip.dart';
import '../../../../core/widgets_for_all_app/financial_card.dart';
import '../../../../core/widgets_for_all_app/gradient_button.dart';
import '../../data/expense_repository.dart';
import '../../data/expense_repository_impl.dart';
import '../../model/expense_model.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _merchantController = TextEditingController();
  final ExpenseRepository _repository = ExpenseRepositoryImpl();
  String _selectedCategory = 'Food & Dining';
  bool _isRecurring = false;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.restaurant_outlined, 'label': 'Food & Dining'},
    {'icon': Icons.directions_car_outlined, 'label': 'Transport'},
    {'icon': Icons.shopping_bag_outlined, 'label': 'Shopping'},
    {'icon': Icons.movie_outlined, 'label': 'Entertainment'},
    {'icon': Icons.favorite_outline, 'label': 'Health'},
    {'icon': Icons.bolt_outlined, 'label': 'Utilities'},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(Dimension.padding16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - Dimension.padding16 * 2,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      _buildHeader(context),
                      const SizedBox(height: Dimension.spacing24),

                      // Amount Input Card
                      _buildAmountCard(context),
                      const SizedBox(height: Dimension.spacing16),

                      // Merchant Name Input
                      _buildMerchantCard(context),
                      const SizedBox(height: Dimension.spacing20),

                      // Category Section
                      _buildCategorySection(context),
                      const SizedBox(height: Dimension.spacing20),

                      // Recurring Expense Toggle
                      _buildRecurringToggle(context),
                      const SizedBox(height: Dimension.spacing16),

                      // Attach Receipt Button
                      _buildAttachReceiptButton(context),

                      const Spacer(),
                      const SizedBox(height: Dimension.spacing24),

                      // Add Expense Button
                      _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColor.purpleEnd,
                              ),
                            )
                          : GradientButton(
                              text: 'Add Expense',
                              onTap: _handleAddExpense,
                            ),
                      const SizedBox(height: Dimension.spacing12),

                      // Offline Status
                      _buildOfflineStatus(context),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Add Expense',
          style: context.fonts.headlineSmall?.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColor.cardBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.close, color: AppColor.gray, size: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimension.padding16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.darkNavy, AppColor.cardBackground],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(Dimension.circular16),
        border: Border.all(color: AppColor.inputFieldBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amount',
            style: context.fonts.bodySmall?.copyWith(color: AppColor.gray),
          ),
          const SizedBox(height: Dimension.spacing8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '\$',
                style: context.fonts.headlineMedium?.copyWith(
                  color: AppColor.blueStart,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: Dimension.spacing4),
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: context.fonts.headlineMedium?.copyWith(
                    color: AppColor.gray,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: context.fonts.headlineMedium?.copyWith(
                      color: AppColor.gray.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMerchantCard(BuildContext context) {
    return FinancialCard(
      color: AppColor.cardBackground,
      borderRadius: Dimension.circular16,
      verticalPadding: Dimension.padding12,
      children: [
        Row(
          children: [
            Icon(Icons.storefront_outlined, color: AppColor.gray, size: 18),
            const SizedBox(width: Dimension.spacing8),
            Text(
              'Merchant Name',
              style: context.fonts.bodySmall?.copyWith(color: AppColor.gray),
            ),
          ],
        ),
        TextField(
          controller: _merchantController,
          style: context.fonts.bodyMedium?.copyWith(color: AppColor.white),
          decoration: InputDecoration(
            hintText: 'Starbucks, Uber, Amazon..',
            hintStyle: context.fonts.bodyMedium?.copyWith(
              color: AppColor.gray.withValues(alpha: 0.6),
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.only(top: Dimension.padding8),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: context.fonts.bodyMedium?.copyWith(color: AppColor.gray),
        ),
        const SizedBox(height: Dimension.spacing12),
        Wrap(
          spacing: Dimension.spacing8,
          runSpacing: Dimension.spacing8,
          children: _categories.map((category) {
            final isSelected = _selectedCategory == category['label'];
            return CategoryChip(
              icon: category['icon'] as IconData,
              label: category['label'] as String,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  _selectedCategory = category['label'] as String;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecurringToggle(BuildContext context) {
    return FinancialCard(
      color: AppColor.cardBackground,
      borderRadius: Dimension.circular16,
      verticalPadding: Dimension.padding12,
      children: [
        Row(
          children: [
            Icon(Icons.sync_outlined, color: AppColor.gray, size: 20),
            const SizedBox(width: Dimension.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recurring Expense',
                    style: context.fonts.bodyMedium?.copyWith(
                      color: AppColor.white,
                    ),
                  ),
                  Text(
                    'Monthly subscription',
                    style: context.fonts.bodySmall?.copyWith(
                      color: AppColor.gray,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: _isRecurring,
              onChanged: (value) {
                setState(() {
                  _isRecurring = value;
                });
              },
              activeThumbColor: AppColor.blueStart,
              activeTrackColor: AppColor.purpleEnd.withValues(alpha: 0.5),
              inactiveThumbColor: AppColor.gray,
              inactiveTrackColor: AppColor.inputFieldBorder,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAttachReceiptButton(BuildContext context) {
    return GestureDetector(
      onTap: _handleAttachReceipt,
      child: FinancialCard(
        color: AppColor.cardBackground,
        borderRadius: Dimension.circular16,
        verticalPadding: Dimension.padding16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt_outlined, color: AppColor.gray, size: 20),
              const SizedBox(width: Dimension.spacing8),
              Text(
                'Attach Receipt (Optional)',
                style: context.fonts.bodyMedium?.copyWith(color: AppColor.gray),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineStatus(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColor.greenOnline,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: Dimension.spacing8),
        Text(
          'Offline-ready · Changes will sync automatically',
          style: context.fonts.bodySmall?.copyWith(
            color: AppColor.gray,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  void _handleAddExpense() async {
    final amountText = _amountController.text.trim();
    final merchant = _merchantController.text.trim();

    if (amountText.isEmpty || merchant.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid amount')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final expense = ExpenseModel(
        id: '', // Firestore will generate this
        amount: amount,
        merchant: merchant,
        category: _selectedCategory,
        isRecurring: _isRecurring,
        date: DateTime.now(),
      );

      await _repository.addExpense(expense);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense added successfully')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleAttachReceipt() {
    // TODO: Implement attach receipt logic
    debugPrint('Attach receipt tapped');
  }
}
