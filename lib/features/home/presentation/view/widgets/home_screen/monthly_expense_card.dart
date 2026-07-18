import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/colors/app_color.dart';
import '../../../../../../core/dimensions/dimension_app.dart';
import '../../../../../../core/extensions/theme_extension.dart';
import '../../../../../../core/widgets_for_all_app/financial_card.dart';
import '../../../../../analytics/presentation/cubit/analytics_cubit.dart';
import '../../../../../analytics/presentation/cubit/analytics_state.dart';

class MonthlyExpenseCard extends StatelessWidget {
  const MonthlyExpenseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsCubit, AnalyticsState>(
      builder: (context, state) {
        double totalExpenses = 0;
        double percentageChange = 0;

        if (state is AnalyticsLoaded) {
          totalExpenses = state.monthTotal;
          percentageChange = state.percentageChange;
        }

        return FinancialCard(
          height: Dimension.heightCard145,
          width: double.infinity,
          verticalPadding: Dimension.spacing16,
          horizontalPadding: Dimension.spacing16,
          color: AppColor.darkOxfordBlue,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('This Month', style: context.fonts.bodyMedium),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimension.spacing8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.deepJungleGreen,
                    borderRadius: BorderRadius.circular(Dimension.circular12),
                  ),
                  child: Text(
                    '${percentageChange.toStringAsFixed(1)}%',
                    style: context.fonts.labelSmall,
                  ),
                ),
              ],
            ),
            Text(
              '\$${totalExpenses.toStringAsFixed(2)}',
              style: context.fonts.displayMedium,
            ),
          ],
        );
      },
    );
  }
}
