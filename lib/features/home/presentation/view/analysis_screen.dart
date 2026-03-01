import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:money/features/home/presentation/providers/home_providers.dart';
import 'package:money/main.dart';

import '../../../../core/colors/app_color.dart';
import '../../../../core/dimensions/Dimension_app.dart';
import '../../../../core/extensions/theme_extension.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  int _selectedPeriod = 1; // 0=Week, 1=Month, 2=Year
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    context.read<AnalyticsNotifier>().loadAnalytics(
      kUserId,
      _currentDate.month,
      _currentDate.year,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimension.padding16,
        vertical: Dimension.padding16,
      ),
      child: SafeArea(
        child: Consumer<AnalyticsNotifier>(
          builder: (context, analytics, _) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Analytics',
                        style: context.fonts.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your spending insights',
                        style: context.fonts.bodyMedium?.copyWith(
                          color: AppColor.gray,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Period Selector
                      _buildPeriodSelector(context),
                      const SizedBox(height: 24),

                      if (analytics.isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColor.blueStart,
                            ),
                          ),
                        )
                      else ...[
                        // Donut Chart
                        _buildDonutChart(context, analytics),
                        const SizedBox(height: 24),

                        // Spending Trend
                        _buildSpendingTrend(context, analytics),
                        const SizedBox(height: 24),

                        // Summary Cards
                        _buildSummaryCards(context, analytics),
                        const SizedBox(height: 100),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPeriodSelector(BuildContext context) {
    final labels = ['Week', 'Month', 'Year'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColor.bottomNavBarBackGround,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: List.generate(
          labels.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPeriod = index;
                  _loadData();
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  gradient: _selectedPeriod == index
                      ? AppColor.navGradient
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[index],
                  style: TextStyle(
                    color: _selectedPeriod == index
                        ? AppColor.white
                        : AppColor.gray,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDonutChart(BuildContext context, AnalyticsNotifier analytics) {
    final categorySpending = analytics.categorySpending;
    final colors = [
      AppColor.blueStart,
      AppColor.purpleEnd,
      AppColor.emeraldGreen,
      AppColor.amberOrange,
      AppColor.lightRed,
      AppColor.softLavender,
      AppColor.cyanCategory,
      AppColor.pinkCategory,
    ];

    final sections = <PieChartSectionData>[];
    int colorIndex = 0;
    categorySpending.forEach((name, value) {
      final percentage = analytics.monthTotal == 0
          ? 0.0
          : (value / analytics.monthTotal) * 100;
      sections.add(
        PieChartSectionData(
          color: colors[colorIndex % colors.length],
          value: value,
          title: '${percentage.toStringAsFixed(0)}%',
          titleStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColor.white,
          ),
          radius: 50,
        ),
      );
      colorIndex++;
    });

    // Empty state
    if (sections.isEmpty) {
      sections.add(
        PieChartSectionData(
          color: AppColor.borderGray,
          value: 1,
          title: '',
          radius: 50,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.bottomNavBarBackGround,
        borderRadius: BorderRadius.circular(Dimension.circular16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spending by Category',
            style: context.fonts.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Legend
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              for (int i = 0; i < categorySpending.length; i++)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: colors[i % colors.length],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      categorySpending.keys.elementAt(i),
                      style: context.fonts.bodySmall?.copyWith(
                        color: AppColor.gray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingTrend(
    BuildContext context,
    AnalyticsNotifier analytics,
  ) {
    final categorySpending = analytics.categorySpending;

    // Build trend spots from category data
    final spots = <FlSpot>[];
    int i = 0;
    categorySpending.values.forEach((value) {
      spots.add(FlSpot(i.toDouble(), value));
      i++;
    });

    // Fallback
    if (spots.isEmpty) {
      spots.add(const FlSpot(0, 0));
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.bottomNavBarBackGround,
        borderRadius: BorderRadius.circular(Dimension.circular16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spending Trend',
            style: context.fonts.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColor.borderGray.withValues(alpha: 0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: AppColor.navGradient,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColor.blueStart.withValues(alpha: 0.3),
                          AppColor.purpleEnd.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, AnalyticsNotifier analytics) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _summaryCard(
                context,
                'Total Expenses',
                '\$${analytics.monthTotal.toStringAsFixed(2)}',
                Icons.arrow_downward,
                AppColor.lightRed,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _summaryCard(
                context,
                'Total Income',
                '\$${analytics.monthIncome.toStringAsFixed(2)}',
                Icons.arrow_upward,
                AppColor.emeraldGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _summaryCard(
                context,
                'Daily Avg',
                '\$${analytics.dailyAverage.toStringAsFixed(2)}',
                Icons.calendar_today,
                AppColor.blueStart,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _summaryCard(
                context,
                'Transactions',
                '${analytics.transactionCount}',
                Icons.receipt_long,
                AppColor.amberOrange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _summaryCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.bottomNavBarBackGround,
        borderRadius: BorderRadius.circular(Dimension.circular16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 10),
          Text(
            value,
            style: context.fonts.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: context.fonts.bodySmall?.copyWith(
              color: AppColor.gray,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
