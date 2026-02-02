import 'package:flutter/cupertino.dart';

import '../../../../../../core/colors/app_color.dart';
import '../../../../../../core/dimensions/Dimension_app.dart';
import '../../../../../../core/widgets_for_all_app/state_sard.dart';

class FinancialStatsGrid extends StatelessWidget {
  const FinancialStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Dimension.spacing16,
      children: [
        Expanded(
          child: StateCard(
            text1: '\$842',
            text2: 'Top Category',
            text3: 'Food & Dining',
            titleColor: AppColor.white,
            midTextColor: AppColor.gray,
            lastTextColor: AppColor.mediumSlateBlue,
            bgColor: AppColor.darkMidnightBlue,
          ),
        ),
        Expanded(
          child: StateCard(
            text1: '47',
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
