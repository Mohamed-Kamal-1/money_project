import 'package:flutter/material.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/dimensions/Dimension_app.dart';
import 'package:money/core/extensions/theme_extension.dart';
import 'package:money/features/expense/data/expense_repository.dart';
import 'package:money/features/expense/data/expense_repository_impl.dart';
import 'package:money/features/expense/model/expense_model.dart';
import 'expense_list_item.dart';

class RecentExpensesSection extends StatefulWidget {
  const RecentExpensesSection({super.key});

  @override
  State<RecentExpensesSection> createState() => _RecentExpensesSectionState();
}

class _RecentExpensesSectionState extends State<RecentExpensesSection> {
  final ExpenseRepository _repository = ExpenseRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'RECENT EXPENSES',
              style: context.fonts.bodySmall?.copyWith(
                color: AppColor.gray,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'See All',
              style: context.fonts.bodySmall?.copyWith(
                color: AppColor.blueStart,
              ),
            ),
          ],
        ),
        const SizedBox(height: Dimension.spacing12),
        StreamBuilder<List<ExpenseModel>>(
          stream: _repository.getExpensesStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(Dimension.padding16),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading expenses',
                  style: TextStyle(color: AppColor.lightRed),
                ),
              );
            }

            final expenses = snapshot.data ?? [];
            if (expenses.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimension.padding24,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        color: AppColor.gray,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No expenses yet',
                        style: TextStyle(color: AppColor.gray),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: expenses.length > 5 ? 5 : expenses.length,
              itemBuilder: (context, index) {
                return ExpenseListItem(expense: expenses[index]);
              },
            );
          },
        ),
      ],
    );
  }
}
