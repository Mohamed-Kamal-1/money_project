import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/colors/app_color.dart';
import '../../../../../../core/dimensions/dimension_app.dart';
import '../../../../../../core/extensions/theme_extension.dart';
import '../../../../../analytics/presentation/cubit/analytics_cubit.dart';
import '../../../../../categories/domain/entities/category.dart';
import '../../../../../categories/presentation/cubit/category_cubit.dart';
import '../../../../../categories/presentation/cubit/category_state.dart';
import '../../../../../transaction/presentation/cubit/transaction/transaction_cubit.dart';
import 'add_transaction_dialog.dart';
import 'quick_actions_button.dart';

class QuickActionsSection extends StatelessWidget {
  final String userId;

  const QuickActionsSection({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Dimension.spacing12,
      children: [
        Text(
          'QUICK ACTIONS',
          style: context.fonts.bodySmall?.copyWith(
            color: AppColor.gray,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          spacing: Dimension.spacing12,
          children: [
            Expanded(
              child: QuickActionsButton(
                onTap: () {
                  // نستخدم CategoryCubit للحصول على الفئات الحالية
                  final state = context.read<CategoryCubit>().state;
                  List<Category> categories = [];
                  if (state is CategoryLoaded) {
                    categories = state.categories;
                  }
                  AddTransactionDialog.show(
                    context,
                    userId: userId,
                    categories: categories,
                    onTransactionAdded: (transaction) async {
                      try {
                        await context
                            .read<TransactionCubit>()
                            .addTransactionWithBalanceUpdate(transaction);
                        // إعادة تحميل التحليلات بعد الإضافة
                        if (context.mounted) {
                          final now = DateTime.now();
                          context.read<AnalyticsCubit>().watchAnalytics(
                            userId,
                            now.month,
                            now.year,
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: ${e.toString()}'),
                              backgroundColor: AppColor.lightRed,
                            ),
                          );
                        }
                      }
                    },
                  );
                },
                iconAndTextColor: AppColor.softLavender,
                icon: Icons.add,
                backgroundColor: AppColor.darkMidnightBlue,
                text: 'Add',
              ),
            ),
            Expanded(
              child: QuickActionsButton(
                onTap: () {
                  Feedback.forTap(context);
                },
                iconAndTextColor: AppColor.emeraldGreen,
                icon: Icons.receipt,
                backgroundColor: AppColor.darkGreen,
                text: 'History',
              ),
            ),
            Expanded(
              child: QuickActionsButton(
                onTap: () {
                  Feedback.forTap(context);
                },
                iconAndTextColor: AppColor.amberOrange,
                icon: Icons.account_balance,
                backgroundColor: AppColor.darkOliveDrab,
                text: 'Budget',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
