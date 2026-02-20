import 'package:flutter/material.dart';

import '../../../../../../../core/colors/app_color.dart';
import '../../../../../../../core/dimensions/Dimension_app.dart';
import '../../../../../../../core/extensions/theme_extension.dart';
import '../../../../../../../core/widgets_for_all_app/custom_linear_indicator.dart';
import '../../../../../../../core/widgets_for_all_app/financial_card.dart';


class FinancialHealthCard extends StatelessWidget {
  const FinancialHealthCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FinancialCard(
      // spacing: Dimension.spacing8,
      height: Dimension.heightCard192,
      width: double.infinity,
      color: AppColor.darkOxfordBlue,
      children: [
        Text('Financial Health', style: context.fonts.bodySmall),
        Text.rich(
          TextSpan(
            text: '78',
            style: context.fonts.displayLarge,
            children: [TextSpan(text: '/100', style: context.fonts.titleLarge)],
          ),
        ),
        CustomPaint(
          size: const Size(double.infinity, 8),
          painter: CustomLinearIndicator(
            progress: 0.78,
            backgroundColor: AppColor.spaceBlue,
            gradientColors: [AppColor.indigoBlue, AppColor.purpleEnd],
          ),
        ),
        // ShaderMask(
        //   shaderCallback: (bounds) => LinearGradient(
        //   stops: [0, 1],
        //     colors: [
        //       AppColor.indigoBlue,
        //       AppColor.purpleEnd,
        //     ],
        //   ).createShader(bounds),
        //   // shaderCallback: (bounds) =>
        //   //     (
        //   //         radius: 20,
        //   //         // center: Alignment.centerRight,
        //   //         tileMode:TileMode.mirror,
        //   //         colors: [
        //   //
        //   //       AppColor.purpleEnd,
        //   //       AppColor.indigoBlue,
        //   //     ]).createShader(bounds),
        //   child: LinearProgressIndicator(
        //     borderRadius: BorderRadius.circular(8),
        //     value: 0.78,
        //     minHeight: 8,
        //     backgroundColor: AppColor.spaceBlue,
        //     valueColor: AlwaysStoppedAnimation(Colors.white),
        //   ),
        // ),
      ],
    );
  }
}
