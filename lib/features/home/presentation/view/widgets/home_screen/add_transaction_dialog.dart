import 'package:flutter/material.dart';

import '../../../../../../core/colors/app_color.dart';
import '../../../../../../core/dimensions/Dimension_app.dart';
import '../../../../domain/models/category_model.dart'; // تأكد من استيراد الـ Model
import '../../../../domain/models/transaction_model.dart'; // تأكد من استيراد الـ Model

class AddTransactionDialog extends StatefulWidget {
  final String userId;
  final List<Category> categories;
  final Function(AppTransaction) onTransactionAdded;

  const AddTransactionDialog({
    super.key,
    required this.userId,
    required this.categories,
    required this.onTransactionAdded,
  });

  static void show(BuildContext context, {
    required String userId,
    required List<Category> categories,
    required Function(AppTransaction) onTransactionAdded,
  }) {
    showDialog(
      context: context,
      builder: (context) =>
          AddTransactionDialog(
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
  final _amountController = TextEditingController();
  String _selectedType = 'expense';
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // اختيار أول فئة تلقائياً لو موجودة
    if (widget.categories.isNotEmpty) {
      _selectedCategory = widget.categories.first;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.bottomNavBarBackGround,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimension.circular16),
      ),
      title: const Text('New Transaction', style: TextStyle(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // حقل المبلغ
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.attach_money, color: Colors.grey),
                hintText: '0.00',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: AppColor.primaryColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimension.circular12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: Dimension.spacing16),

            // اختيار النوع (Expense / Income)
            Row(
              children: [
                Expanded(
                  child: _TypeOption(
                    label: 'Expense',
                    isSelected: _selectedType == 'expense',
                    activeColor: AppColor.lightRed,
                    onTap: () => setState(() => _selectedType = 'expense'),
                  ),
                ),
                const SizedBox(width: Dimension.spacing8),
                Expanded(
                  child: _TypeOption(
                    label: 'Income',
                    isSelected: _selectedType == 'income',
                    activeColor: AppColor.emeraldGreen,
                    onTap: () => setState(() => _selectedType = 'income'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimension.spacing16),

            // Dropdown لاختيار الفئة
            if (widget.categories.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<Category>(
                  value: _selectedCategory,
                  isExpanded: true,
                  underline: const SizedBox(),
                  dropdownColor: AppColor.bottomNavBarBackGround,
                  items: widget.categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(cat.name, style: const TextStyle(
                          color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedCategory = val),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.blueStart,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          onPressed: _handleSave,
          child: const Text('Save', style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  void _handleSave() {
    final amount = double.tryParse(_amountController.text);
    if (amount != null && amount > 0) {
      final newTransaction = AppTransaction(
        id: '',
        userId: widget.userId,
        amount: amount,
        type: _selectedType,
        categoryId: _selectedCategory?.id ?? 'uncategorized',
        categoryName: _selectedCategory?.name ?? 'General',
        description: 'New $_selectedType', // إضافة وصف افتراضي للتوافق مع الموديل
        date: DateTime.now(),
      );

      widget.onTransactionAdded(newTransaction);

      // التكة المهمة: قفل الدايلوج بعد النجاح
      if (mounted) Navigator.pop(context);
    } else {
      // اختياري: تنبيه المستخدم إن المبلغ غير صحيح
    }
  }
}

// الكلاس الخاص باختيار النوع (Private Class)
class _TypeOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const _TypeOption({
    required this.label,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: Dimension.spacing12),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : AppColor.primaryColor,
          borderRadius: BorderRadius.circular(Dimension.circular8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}