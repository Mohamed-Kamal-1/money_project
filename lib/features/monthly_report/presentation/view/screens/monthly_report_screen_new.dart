import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/dimensions/dimension_app.dart';
import 'package:money/features/analytics/presentation/cubit/analytics_cubit.dart';
import 'package:money/features/analytics/presentation/cubit/analytics_state.dart';
import 'package:money/features/home/presentation/view/settings_screen.dart';
import 'package:money/features/monthly_report/presentation/cubit/monthly_report_cubit.dart';
import 'package:money/features/monthly_report/presentation/view/widgets/achievements_card.dart';
import 'package:money/features/monthly_report/presentation/view/widgets/comparison_row.dart';
import 'package:money/features/monthly_report/presentation/view/widgets/export_buttons.dart';
import 'package:money/features/monthly_report/presentation/view/widgets/month_selector.dart';
import 'package:money/features/monthly_report/presentation/view/widgets/monthly_report_header.dart';
import 'package:money/features/monthly_report/presentation/view/widgets/pdf_generator.dart';
import 'package:money/features/monthly_report/presentation/view/widgets/previous_reports_section.dart';
import 'package:money/features/monthly_report/presentation/view/widgets/spending_behavior.dart';
import 'package:money/features/monthly_report/presentation/view/widgets/top_categories.dart';
import 'package:money/features/monthly_report/presentation/view/widgets/total_expenses_card.dart';
import 'package:money/features/transaction/domain/entities/transaction.dart';
import 'package:money/features/transaction/presentation/cubit/transaction/transaction_cubit.dart';
import 'package:money/features/transaction/presentation/cubit/transaction/transaction_state.dart';

class MonthlyReportScreen extends StatefulWidget {
  final String userId;

  const MonthlyReportScreen({super.key, required this.userId});

  @override
  State<MonthlyReportScreen> createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
    context.read<MonthlyReportCubit>().listenToReports(widget.userId);
    context.read<TransactionCubit>().listenToTransactions(widget.userId);
    _loadAnalytics();
  }

  void _loadAnalytics() {
    if (_selectedMonth != null) {
      context.read<AnalyticsCubit>().watchAnalytics(
        widget.userId,
        _selectedMonth.month,
        _selectedMonth.year,
      );
    }
  }

  void _onMonthChanged(DateTime newMonth) {
    setState(() {
      _selectedMonth = newMonth;
      _loadAnalytics();
    });
  }

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Header مع `selectedMonth` و `onSettingsTap`
                  MonthlyReportHeader(
                    selectedMonth: _selectedMonth,
                    onSettingsTap: () => SettingsScreen.show(context),
                  ),
                  const SizedBox(height: 20),

                  // Month Selector
                  MonthSelector(
                    selectedMonth: _selectedMonth,
                    onPrevious: () {
                      _onMonthChanged(
                        DateTime(_selectedMonth.year, _selectedMonth.month - 1),
                      );
                    },
                    onNext: () {
                      _onMonthChanged(
                        DateTime(_selectedMonth.year, _selectedMonth.month + 1),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Analytics Content
                  BlocBuilder<AnalyticsCubit, AnalyticsState>(
                    builder: (context, analyticsState) {
                      if (analyticsState is AnalyticsLoading) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColor.blueStart,
                            ),
                          ),
                        );
                      }
                      if (analyticsState is AnalyticsError) {
                        return Center(
                          child: Text(
                            'Error: ${analyticsState.message}',
                            style: const TextStyle(color: AppColor.lightRed),
                          ),
                        );
                      }
                      if (analyticsState is AnalyticsLoaded) {
                        return Column(
                          children: [
                            TotalExpensesCard(analytics: analyticsState),
                            const SizedBox(height: 20),
                            ComparisonRow(
                              analytics: analyticsState,
                              selectedMonth: _selectedMonth,
                            ),
                            const SizedBox(height: 24),
                            TopCategories(analytics: analyticsState),
                            const SizedBox(height: 24),
                            SpendingBehavior(analytics: analyticsState),
                            const SizedBox(height: 24),
                            AchievementsCard(analytics: analyticsState),
                            const SizedBox(height: 24),

                            // Export Buttons with Transactions
                            BlocBuilder<TransactionCubit, TransactionState>(
                              builder: (context, txState) {
                                List<AppTransaction> transactions = [];
                                if (txState is TransactionLoaded) {
                                  transactions = txState.transactions;
                                }
                                return ExportButtons(
                                  onExportPDF: () async {
                                    await PdfGenerator.generateAndShowPDF(
                                      context,
                                      analyticsState,
                                      _selectedMonth,
                                      transactions,
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 24),

                            const PreviousReportsSection(),
                            const SizedBox(height: 100),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
