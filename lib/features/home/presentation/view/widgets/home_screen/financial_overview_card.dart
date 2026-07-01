import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money/main.dart';

import '../../../../../../core/colors/app_color.dart';
import '../../../../../../core/dimensions/dimension_app.dart';
import '../../../../../../core/extensions/theme_extension.dart';
import '../../../../../../core/widgets_for_all_app/financial_card.dart';
import '../../../providers/home_providers.dart';

class FinancialOverviewCard extends StatelessWidget {
  const FinancialOverviewCard({super.key});

  void _showUpdateBalanceDialog(BuildContext context) {
    final controller = TextEditingController();
    final balanceNotifier = context.read<BalanceNotifier>();

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
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null) {
                balanceNotifier.updateBalance(kUserId, amount);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Balance updated to \$${amount.toStringAsFixed(2)}',
                    ),
                    backgroundColor: AppColor.emeraldGreen,
                  ),
                );
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
      child: Consumer2<BalanceNotifier, AnalyticsNotifier>(
        builder: (context, balanceNotifier, analyticsNotifier, _) {
          final balance = balanceNotifier.balance;
          final expenses = analyticsNotifier.monthTotal;
          final income = analyticsNotifier.monthIncome;

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

              Row(
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
                          textAlign: TextAlign.start,
                          'Income',
                          style: context.fonts.labelSmall?.copyWith(
                            color: AppColor.darkTeal,
                          ),
                        ),
                        Text(
                          textAlign: TextAlign.end,
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
              ),
            ],
          );
        },
      ),
    );
  }
}
