import 'package:flutter/material.dart';
import '../../../../../../core/colors/app_color.dart';
import '../../../../../../core/dimensions/Dimension_app.dart';
import '../../../../../../core/extensions/theme_extension.dart';
import '../../../../../../core/widgets_for_all_app/custom_linear_indicator.dart';
import '../../../../../../core/widgets_for_all_app/financial_card.dart';

class FinancialHealthCard extends StatelessWidget {
  final double score; // من 0 لـ 100

  const FinancialHealthCard({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    // حساب النسبة المئوية للـ Custom Painter
    final double progress = (score / 100).clamp(0.0, 1.0);

    return FinancialCard(
      height: Dimension.heightCard192,
      width: double.infinity,
      color: AppColor.darkOxfordBlue,
      children: [
        Text('Financial Health', style: context.fonts.bodySmall),
        Text.rich(
          TextSpan(
            text: score.toInt().toString(),
            style: context.fonts.displayLarge,
            children: [
              TextSpan(text: '/100', style: context.fonts.titleLarge),
            ],
          ),
        ),
        const SizedBox(height: Dimension.spacing8),
        CustomPaint(
          size: const Size(double.infinity, 8),
          painter: CustomLinearIndicator(
            progress: progress,
            backgroundColor: AppColor.spaceBlue,
            gradientColors: const [AppColor.indigoBlue, AppColor.purpleEnd],
          ),
        ),
      ],
    );
  }
}