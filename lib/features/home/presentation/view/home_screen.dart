import 'package:flutter/material.dart';
import 'package:money/core/dimensions/Dimension_app.dart';
import 'package:money/features/home/presentation/view/widgets/home_screen/financial_health_card.dart';
import 'package:money/features/home/presentation/view/widgets/home_screen/financial_overview_card.dart';
import 'package:money/features/home/presentation/view/widgets/home_screen/financial_stats_grid.dart';
import 'package:money/features/home/presentation/view/widgets/home_screen/monthly_expense_card.dart';
import 'package:money/features/home/presentation/view/widgets/home_screen/quick_actions_section.dart';

import '../../../../core/extensions/theme_extension.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Text('January 2026', style: context.fonts.bodyMedium),
                  // const RepaintBoundary(child: FinancialOverviewCard()),
                  // const RepaintBoundary(child: FinancialHealthCard()),
                  // const RepaintBoundary(child: MonthlyExpenseCard()),
                  // const RepaintBoundary(child: FinancialStatsGrid()),
                  const FinancialOverviewCard(),
                  const FinancialHealthCard(),
                  const MonthlyExpenseCard(),
                  const FinancialStatsGrid(),
                  const QuickActionsSection(),
                ],
              ),
            ),
          ],
        ),
        // child: SingleChildScrollView(
        //   child: Column(
        //     spacing: Dimension.padding20,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text('Financial Overview', style: context.fonts.headlineSmall),
        //       Text('January 2026', style: context.fonts.bodyMedium),
        //       const RepaintBoundary(child: FinancialOverviewCard()),
        //       const RepaintBoundary(child: FinancialHealthCard()),
        //       const RepaintBoundary(child: MonthlyExpenseCard()),
        //       const RepaintBoundary(child: FinancialStatsGrid()),
        //       const RepaintBoundary(child: QuickActionsSection()),
        //
        //
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
