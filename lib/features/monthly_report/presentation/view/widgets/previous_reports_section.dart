import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/dimensions/dimension_app.dart';
import 'package:money/core/extensions/theme_extension.dart';
import 'package:money/features/monthly_report/domain/entities/monthly_report.dart';
import 'package:money/features/monthly_report/presentation/cubit/monthly_report_cubit.dart';
import 'package:money/features/monthly_report/presentation/cubit/monthly_report_state.dart';

class PreviousReportsSection extends StatelessWidget {
  const PreviousReportsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MonthlyReportCubit, MonthlyReportState>(
      builder: (context, reportState) {
        List<MonthlyReport> reports = [];
        if (reportState is MonthlyReportLoaded) {
          reports = reportState.reports;
        }
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.bottomNavBarBackGround,
            borderRadius: BorderRadius.circular(Dimension.circular16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Previous Reports',
                style: context.fonts.bodySmall?.copyWith(
                  color: AppColor.gray,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              if (reports.isEmpty)
                Text(
                  'No previous reports yet',
                  style: context.fonts.bodyMedium?.copyWith(
                    color: AppColor.gray,
                  ),
                )
              else
                ...reports.take(5).map((report) {
                  const months = [
                    'Jan',
                    'Feb',
                    'Mar',
                    'Apr',
                    'May',
                    'Jun',
                    'Jul',
                    'Aug',
                    'Sep',
                    'Oct',
                    'Nov',
                    'Dec',
                  ];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColor.borderGray),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${months[report.month - 1]} ${report.year}',
                            style: context.fonts.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '\$${report.totalExpenses.toStringAsFixed(2)}',
                                style: context.fonts.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.lightRed,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: (report.percentageChange ?? 0) > 0
                                      ? AppColor.lightRed.withValues(
                                          alpha: 0.15,
                                        )
                                      : AppColor.emeraldGreen.withValues(
                                          alpha: 0.15,
                                        ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${(report.percentageChange ?? 0) > 0 ? '+' : ''}${(report.percentageChange ?? 0).toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: (report.percentageChange ?? 0) > 0
                                        ? AppColor.lightRed
                                        : AppColor.emeraldGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}
