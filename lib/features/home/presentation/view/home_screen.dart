import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money/core/dimensions/dimension_app.dart';
import 'package:money/features/home/presentation/view/widgets/home_screen/financial_health_card.dart';
import 'package:money/features/home/presentation/view/widgets/home_screen/financial_overview_card.dart';
import 'package:money/features/home/presentation/view/widgets/home_screen/monthly_expense_card.dart';
import 'package:money/features/home/presentation/view/widgets/home_screen/quick_actions_section.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../analytics/presentation/cubit/analytics_cubit.dart';
import '../../../balance/presentation/cubit/balance_cubit.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({super.key, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BalanceCubit>().listenToBalance(widget.userId);
    final now = DateTime.now();
    context.read<AnalyticsCubit>().loadAnalytics(
      widget.userId,
      now.month,
      now.year,
    );
  }

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
                  FinancialOverviewCard(userId: widget.userId),
                  const FinancialHealthCard(),
                  const MonthlyExpenseCard(),
                  // const FinancialStatsGrid(),
                  QuickActionsSection(userId: widget.userId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
