import 'package:flutter/material.dart';
import '../../../../../../core/colors/app_color.dart';
import '../../../../../../core/dimensions/Dimension_app.dart';
import '../../../../../../core/widgets_for_all_app/state_sard.dart';

class FinancialStatsGrid extends StatelessWidget {
  final String topCategory;
  final double topAmount;
  final int transactionCount;

  const FinancialStatsGrid({
    super.key,
    required this.topCategory,
    required this.topAmount,
    required this.transactionCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StateCard(
            text1: '\$${topAmount.toInt()}',
            text2: 'Top Category',
            text3: topCategory,
            titleColor: AppColor.white,
            midTextColor: AppColor.gray,
            lastTextColor: AppColor.mediumSlateBlue,
            bgColor: AppColor.darkMidnightBlue,
          ),
        ),
        const SizedBox(width: Dimension.spacing16),
        Expanded(
          child: StateCard(
            text1: transactionCount.toString(),
            text2: 'Transactions',
            text3: 'This Month',
            titleColor: AppColor.white,
            midTextColor: AppColor.gray,
            lastTextColor: AppColor.emeraldGreen,
            bgColor: AppColor.darkMidnightBlue,
          ),
        ),
      ],
    );
  }
}