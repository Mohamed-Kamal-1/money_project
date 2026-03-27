import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money/features/home/presentation/view/widgets/ai_widget.dart';
import 'package:money/features/home/presentation/view/widgets/home_screen/financial_health_card.dart';

import '../../../../core/dimensions/Dimension_app.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../view_model/cubit/home_cubit.dart';
import '../view_model/cubit/home_state.dart';
import 'widgets/home_screen/financial_overview_card.dart';
import 'widgets/home_screen/update_balance_dialog.dart';
// ... بقية الـ imports للـ Classes التانية

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HomeError) {
          return Center(child: Text(state.message));
        }

        if (state is HomeSuccess) {
          return _HomeBodyContent(data: state);
        }

        return const SizedBox();
      },
    );
  }
}

// تحويل الجزء الداخلي لـ Private Class لضمان أفضل Performance
class _HomeBodyContent extends StatelessWidget {
  final HomeSuccess data;

  const _HomeBodyContent({required this.data});

  @override
  Widget build(BuildContext context) {
    final monthLabel = DateFormat('MMMM yyyy').format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.all(Dimension.padding16),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Financial Overview', style: context.fonts.headlineSmall),
                  Text(monthLabel, style: context.fonts.bodyMedium),
                  const SizedBox(height: Dimension.padding20),

                  FinancialOverviewCard(
                    balance: data.balance,
                    income: data.monthlyIncome,
                    expenses: data.monthlyExpenses,
                    onUpdateTap: () =>
                        UpdateBalanceDialog.show(
                            context,
                                (newVal) =>
                                context.read<HomeCubit>().updateBalance(
                                    'my_static_user_001', newVal)
                        ),
                  ),

                  const SizedBox(height: Dimension.padding20),
                  FinancialHealthCard(score: data.healthScore),

                  const SizedBox(height: Dimension.padding20),
                  MonthlyExpenseCard(current: data.monthlyExpenses,
                      previous: data.lastMonthExpenses),

                  const SizedBox(height: Dimension.padding20),
                  FinancialStatsGrid(
                    topCategory: data.topCategory,
                    topAmount: data.topCategoryAmount,
                    transactions: data.transactionCount,
                  ),

                  const SizedBox(height: Dimension.padding20),
                  const QuickActionsSection(),

                  const SizedBox(height: 100), // Space for bottom nav
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}