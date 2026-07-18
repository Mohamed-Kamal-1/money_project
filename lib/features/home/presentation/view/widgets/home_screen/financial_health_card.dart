import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/colors/app_color.dart';
import '../../../../../../core/dimensions/dimension_app.dart';
import '../../../../../../core/extensions/theme_extension.dart';
import '../../../../../../core/widgets_for_all_app/custom_linear_indicator.dart';
import '../../../../../../core/widgets_for_all_app/financial_card.dart';
import '../../../../../analytics/presentation/cubit/analytics_cubit.dart';
import '../../../../../analytics/presentation/cubit/analytics_state.dart';

class FinancialHealthCard extends StatelessWidget {
  const FinancialHealthCard({super.key});

  double _calculateHealthScore(double income, double expenses) {
    if (income <= 0) return 0;
    final ratio = (income - expenses) / income;
    return (ratio.clamp(0, 1) * 100);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsCubit, AnalyticsState>(
      builder: (context, state) {
        double score = 0;
        double progress = 0;

        if (state is AnalyticsLoaded) {
          final income = state.monthIncome;
          final expenses = state.monthTotal;
          score = _calculateHealthScore(income, expenses);
          progress = score / 100;
        }

        return FinancialCard(
          height: Dimension.heightCard192,
          width: double.infinity,
          color: AppColor.darkOxfordBlue,
          children: [
            Text('Financial Health', style: context.fonts.bodySmall),
            Text.rich(
              TextSpan(
                text: '${score.toInt()}',
                style: context.fonts.displayLarge,
                children: [
                  TextSpan(text: '/100', style: context.fonts.titleLarge),
                ],
              ),
            ),
            CustomPaint(
              size: const Size(double.infinity, 8),
              painter: CustomLinearIndicator(
                progress: progress,
                backgroundColor: AppColor.spaceBlue,
                gradientColors: [AppColor.indigoBlue, AppColor.purpleEnd],
              ),
            ),
          ],
        );
      },
    );
  }
}
