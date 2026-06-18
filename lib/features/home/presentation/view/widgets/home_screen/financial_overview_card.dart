import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/colors/app_color.dart';
import '../../../../../../core/dimensions/dimension_app.dart';
import '../../../../../../core/extensions/theme_extension.dart';
import '../../../../../../core/widgets_for_all_app/financial_card.dart';
import '../../../../../analytics/presentation/cubit/analytics_cubit.dart';
import '../../../../../analytics/presentation/cubit/analytics_state.dart';
import '../../../../../balance/presentation/cubit/balance_cubit.dart';
import '../../../../../balance/presentation/cubit/balance_state.dart';

class FinancialOverviewCard extends StatefulWidget {
  final String userId;
  const FinancialOverviewCard({super.key, required this.userId});

  @override
  State<FinancialOverviewCard> createState() => _FinancialOverviewCardState();
}

class _FinancialOverviewCardState extends State<FinancialOverviewCard> {
  late final String userId;

  @override
  void initState() {
    super.initState();
    userId = widget.userId; // لاحقاً: context.read<AuthCubit>().state.userId
    context.read<BalanceCubit>().listenToBalance(userId);
    final now = DateTime.now();
    context.read<AnalyticsCubit>().loadAnalytics(userId, now.month, now.year);
  }

  void _showUpdateBalanceDialog(BuildContext context) {
    final controller = TextEditingController();
    final balanceCubit = context.read<BalanceCubit>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColor.bottomNavBarBackGround,
        title: Text(
          'Update Balance',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColor.white),
          decoration: InputDecoration(
            prefixText: '\$ ',
            prefixStyle: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColor.white),
            hintText: 'Enter new balance',
            hintStyle: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColor.gray),
            filled: true,
            fillColor: AppColor.primaryColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.borderGray),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColor.gray),
            ),
          ),
          TextButton(
            onPressed: () async {
              final amount = double.tryParse(controller.text);
              if (amount != null) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Updating balance to \$${amount.toStringAsFixed(2)}...',
                    ),
                    backgroundColor: AppColor.emeraldGreen,
                  ),
                );
                try {
                  await balanceCubit.updateBalance(userId, amount);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Balance updated to \$${amount.toStringAsFixed(2)}',
                        ),
                        backgroundColor: AppColor.emeraldGreen,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: AppColor.lightRed,
                      ),
                    );
                  }
                }
              }
            },
            child: Text(
              'Update',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColor.blueStart),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showUpdateBalanceDialog(context),
      child: BlocBuilder<BalanceCubit, BalanceState>(
        builder: (context, balanceState) {
          double balance = 0.0;
          if (balanceState is BalanceLoaded) {
            balance = balanceState.balance;
          } else if (balanceState is BalanceError) {
            // يمكن إظهار رسالة خطأ صغيرة هنا إذا أردت
          }
          return FinancialCard(
            height: Dimension.heightCard245,
            width: double.infinity,
            color: AppColor.darkGreen,
            children: [
              Row(
                spacing: Dimension.spacing8,
                children: [
                  const Icon(
                    Icons.wallet,
                    size: Dimension.size30,
                    color: AppColor.lightGreen,
                  ),
                  Text('Current Balance', style: context.fonts.labelSmall),
                  const Spacer(),
                  const Icon(Icons.edit, size: 16, color: AppColor.gray),
                ],
              ),
              Text(
                '\$${balance.toStringAsFixed(2)}',
                style: context.fonts.displayMedium,
              ),
              _buildIncomeExpenseRow(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIncomeExpenseRow(BuildContext context) {
    return BlocBuilder<AnalyticsCubit, AnalyticsState>(
      builder: (context, analyticsState) {
        double income = 0.0;
        double expenses = 0.0;
        if (analyticsState is AnalyticsLoaded) {
          income = analyticsState.monthIncome;
          expenses = analyticsState.monthTotal;
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          spacing: Dimension.spacing12,
          children: [
            Expanded(
              child: FinancialCard(
                spacing: Dimension.spacing8,
                alignment: MainAxisAlignment.center,
                borderRadius: Dimension.circular16,
                height: Dimension.heightCard79,
                color: AppColor.secondaryGreen,
                children: [
                  Text(
                    'Income',
                    style: context.fonts.labelSmall?.copyWith(
                      color: AppColor.darkTeal,
                    ),
                  ),
                  Text(
                    '\$${income.toStringAsFixed(2)}',
                    style: context.fonts.titleMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: FinancialCard(
                spacing: Dimension.spacing8,
                alignment: MainAxisAlignment.center,
                borderRadius: Dimension.circular16,
                height: Dimension.heightCard79,
                color: AppColor.secondaryGreen,
                children: [
                  Text(
                    'Expenses',
                    style: context.fonts.labelSmall?.copyWith(
                      color: AppColor.lightRed,
                    ),
                  ),
                  Text(
                    '\$${expenses.toStringAsFixed(2)}',
                    style: context.fonts.titleMedium?.copyWith(
                      color: AppColor.lightRed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
