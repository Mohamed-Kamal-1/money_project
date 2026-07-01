import 'package:flutter/material.dart';
import 'package:money/features/home/presentation/view/widgets/home_screen/add_transaction_dialog.dart';
import 'package:money/features/home/presentation/view/widgets/home_screen/quick_actions_button.dart';
import 'package:provider/provider.dart';
import 'package:money/features/home/presentation/providers/home_providers.dart';
import 'package:money/main.dart';

import '../../../../../../core/colors/app_color.dart';
import '../../../../../../core/dimensions/dimension_app.dart';
import '../../../../../../core/extensions/theme_extension.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

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
                  final categories = context
                      .read<CategoryNotifier>()
                      .categories;
                  AddTransactionDialog.show(
                    context,
                    userId: kUserId,
                    categories: categories,
                    onTransactionAdded: (transaction) async {
                      try {
                        await context
                            .read<TransactionNotifier>()
                            .addTransactionWithBalanceUpdate(transaction);
                        // Reload analytics
                        if (context.mounted) {
                          final now = DateTime.now();
                          context.read<AnalyticsNotifier>().loadAnalytics(
                            kUserId,
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
