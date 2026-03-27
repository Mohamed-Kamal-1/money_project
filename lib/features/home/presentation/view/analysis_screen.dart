import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money/features/home/presentation/view/widgets/analysis/donut_chart_painter.dart';

import '../../../../../../core/colors/app_color.dart';
import '../../../../../../core/dimensions/Dimension_app.dart';
import '../view_model/cubit/analysis/analysis_cubit.dart';
import '../view_model/cubit/analysis/analysis_state.dart';


class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bottomNavBarBackGround,
      appBar: AppBar(
        title: const Text('Financial Analysis',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<AnalysisCubit, AnalysisState>(
        builder: (context, state) {
          if (state is AnalysisLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppColor.blueStart));
          } else if (state is AnalysisSuccess) {
            return CustomScrollView(
              slivers: [
                // 1. قسم الرسم البياني (The Chart)
                SliverToBoxAdapter(
                  child: _ChartSection(
                      segments: state.segments, total: state.monthTotal),
                ),

                // 2. كروت الملخص (Daily Average & Top Category)
                SliverToBoxAdapter(
                  child: _SpendingSummaryCards(
                    dailyAvg: state.dailyAverage,
                    topCategory: state.topCategory,
                  ),
                ),

                // 3. قائمة توزيع الفئات (List of Categories)
                SliverPadding(
                  padding: const EdgeInsets.all(Dimension.spacing16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final segment = state.segments[index];
                        return _CategoryItem(segment: segment);
                      },
                      childCount: state.segments.length,
                    ),
                  ),
                ),
              ],
            );
          } else if (state is AnalysisError) {
            return Center(child: Text(
                state.message, style: const TextStyle(color: Colors.red)));
          }
          return const SizedBox();
        },
      ),
    );
  }
}

// --- Private Widgets لضمان أفضل أداء (No unnecessary rebuilds) ---

class _ChartSection extends StatelessWidget {
  final List<DonutSegment> segments;
  final double total;

  const _ChartSection({required this.segments, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(vertical: Dimension.spacing24),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(220, 220),
            painter: DonutChartPainter(segments: segments, strokeWidth: 28),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total Spent',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14)),
              const SizedBox(height: 4),
              Text('\$${total.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final DonutSegment segment;

  const _CategoryItem({required this.segment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimension.spacing12),
      padding: const EdgeInsets.all(Dimension.spacing12),
      decoration: BoxDecoration(
        color: AppColor.primaryColor,
        borderRadius: BorderRadius.circular(Dimension.circular12),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 6, backgroundColor: segment.color),
          const SizedBox(width: 12),
          Text(segment.label, style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500)),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${segment.amount.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white)),
              Text('${segment.percentage.toStringAsFixed(1)}%',
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpendingSummaryCards extends StatelessWidget {
  final double dailyAvg;
  final String topCategory;

  const _SpendingSummaryCards(
      {required this.dailyAvg, required this.topCategory});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimension.spacing16),
      child: Row(
        children: [
          _buildSmallCard('Daily Avg', '\$${dailyAvg.toStringAsFixed(1)}',
              AppColor.blueStart),
          const SizedBox(width: Dimension.spacing12),
          _buildSmallCard('Top Category', topCategory, AppColor.emeraldGreen),
        ],
      ),
    );
  }

  Widget _buildSmallCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(Dimension.spacing16),
        decoration: BoxDecoration(
          color: AppColor.primaryColor,
          borderRadius: BorderRadius.circular(Dimension.circular16),
          border: Border(left: BorderSide(color: color, width: 4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}