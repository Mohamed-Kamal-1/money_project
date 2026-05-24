import 'package:flutter/material.dart';
import 'package:money/core/dimensions/dimension_app.dart';
import 'package:money/features/home/presentation/view/widgets/home_screen/financial_health_card.dart';
import 'package:money/features/home/presentation/view/widgets/home_screen/financial_overview_card.dart';
import 'package:money/features/home/presentation/view/widgets/home_screen/monthly_expense_card.dart';
import 'package:money/features/home/presentation/view/widgets/home_screen/quick_actions_section.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/theme_extension.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monthLabel = DateFormat('MMMM yyyy').format(now);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimension.padding16,
        vertical: Dimension.padding16,
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                spacing: Dimension.padding20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Financial Overview',
                    style: context.fonts.headlineSmall,
                  ),
                  Text(monthLabel, style: context.fonts.bodyMedium),
                  const FinancialOverviewCard(),
                  const FinancialHealthCard(),
                  const MonthlyExpenseCard(),
                  // const FinancialStatsGrid(),
                  const QuickActionsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
